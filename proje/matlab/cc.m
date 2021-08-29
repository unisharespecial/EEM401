h = fspecial('motion',50,45); 
filteredRGB = filtering(I,h); 
figure, imshow(I), figure, imshow(filteredRGB)
boundaryReplicateRGB = imfilter(I,h,'replicate'); 
figure, imshow(boundaryReplicateRGB)

function b = filtering(varargin)

[a,h,boundary,flags] = parse_inputs(varargin{:});
  
rank_a = ndims(a);
rank_h = ndims(h);

% Pad dimensions with ones if filter and image rank are different
size_h = [size(h) ones(1,rank_a-rank_h)];
size_a = [size(a) ones(1,rank_h-rank_a)];

if bitand(flags,8)
  %Full output
  im_size = size_a+size_h-1;
  pad = size_h - 1;
else
  %Same output
  im_size = size_a;

  %Calculate the number of pad pixels
  filter_center = floor((size_h + 1)/2);
  pad = size_h - filter_center;
end

%Empty Inputs
% 'Same' output then size(b) = size(a)
% 'Full' output then size(b) = size(h)+size(a)-1 
if isempty(a)
  if bitand(flags,4) %Same
    b = a;
  else %Full
    if all(im_size>0)
      b = a;
      b = b(:);
      b(prod(im_size)) = 0;
      b = reshape(b,im_size);
    elseif all(im_size>=0)
      b = feval(class(a),zeros(im_size));
    else
      eid = sprintf('Images:%s:negativeDimensionBadSizeB',mfilename);
      msg = ['Error in size of B.  At least one dimension is negative. ',...
             '\n''Full'' output size calculation is: size(B) = size(A) ',...
             '+ size(H) - 1.'];
      error(eid,msg);
    end
  end
  return;
end

if  isempty(h)
  if bitand(flags,4) %Same
    b = a;
    b(:) = 0;
  else %Full
    if all(im_size>0)
      b = a;
      if all(im_size<size_a)  %Output is smaller than input
        b(:) = [];
      else %Grow the array, is this a no-op?
        b(:) = 0;
        b = b(:);
      end
      b(prod(im_size)) = 0;
      b = reshape(b,im_size);
    elseif all(im_size>=0)
      b = feval(class(a),zeros(im_size));
    else
      eid = sprintf('Images:%s:negativeDimensionBadSizeB',mfilename);
      msg = ['Error in size of B.  At least one dimension is negative. ',...
             '\n''Full'' output size calculation is: size(B) = size(A) +',...
             ' size(H) - 1.'];
      error(eid,msg);
    end
  end
  return;
end

im_size = im_size;

%Starting point in padded image, zero based.
start = pad;

%Pad image
a = padarray(a,pad,boundary,'both');

% check for filter separability only if the kernel has at least
% 289 elements [17x17] (non-double input) or 49 [7x7] (double input),
% both the image and the filter kernel are two-dimensional and the
% kernel is not a row or column vector, nor does it contain any NaNs of Infs
separable = false;
numel_h = numel(h);
if isa(a,'double')
  sep_threshold = (numel_h >= 49);
else
  sep_threshold = (numel_h >= 289);
end

if sep_threshold && (rank_a == 2) && (rank_h == 2) && ...
      all(size(h) ~= 1) && ~any(isnan(h(:))) && ~any(isinf(h(:)))
  [u,s,v] = svd(h);
  s = diag(s);
  tol = length(h) * max(s) * eps;
  rank = sum(s > tol);
  if (rank == 1)
    separable = true;
  end
end

% Separate real and imaginary parts of the filter (h) in the M-code and
% filter imaginary and real parts of the image (a) in the mex code. 
if separable
  % extract the components of the separable filter
  hcol = u(:,1) * sqrt(s(1));
  hrow = v(:,1)' * sqrt(s(1));
  
  % Create connectivity matrix.  Only use nonzero values of the filter.
  conn_logical_row = hrow~=0;
  conn_row = double(conn_logical_row); %input to the mex file must be double
  nonzero_h_row = hrow(conn_logical_row);

  conn_logical_col = hcol~=0;
  conn_col = double(conn_logical_col); %input to the mex file must be double
  nonzero_h_col = hcol(conn_logical_col);

  % intermediate results should be stored in doubles in order to
  % maintain sufficient precision
  class_of_a = class(a);
  change_class = false;
  if ~strcmp(class_of_a,'double')
    change_class = true;
    a = double(a);
  end

  % apply the first component of the separable filter (hrow)
  checkMexFileInputs(a,im_size,real(hrow),real(nonzero_h_row),conn_row,...
                     start,flags);  
  b_row_applied = imfilter_mex(a,im_size,real(hrow),real(nonzero_h_row),...
                               conn_row,start,flags);

  if ~isreal(hrow)
    b_row_applied_cmplx = imfilter_mex(a,im_size,imag(hrow),...
                                       imag(nonzero_h_row),conn_row,...
                                       start,flags);    
    if isreal(a)
      % b_row_applied and b_row_applied_cmplx will always be real;
      % result will always be complex
      b_row_applied = complex(b_row_applied,b_row_applied_cmplx);
    else
      % b_row_applied and/or b_row_applied_cmplx may be complex;
      % result will always be complex
      b_row_applied = complex(imsubtract(real(b_row_applied),...
                                         imag(b_row_applied_cmplx)),...
                              imadd(imag(b_row_applied),...
                                    real(b_row_applied_cmplx)));
    end
  end
  
  % apply the other component of the separable filter (hcol)
  
  % prepare b_next which is an intermediate result after applying both
  % real and complex parts of hrow to the input image
  b_row_applied = padarray(b_row_applied,pad,boundary,'both');
  
  checkMexFileInputs(b_row_applied,im_size,real(hcol),real(nonzero_h_col),...
                     conn_col,start,flags);
  b1 = imfilter_mex(b_row_applied,im_size,real(hcol),real(nonzero_h_col),...
                    conn_col,start,flags);

  if ~isreal(hcol)
    b2 = imfilter_mex(b_row_applied,im_size,imag(hcol),imag(nonzero_h_col),...
                      conn_col,start,flags);
    if change_class
      b2 = feval(class_of_a,b2);
    end
  end
  
  % change the class back if necessary  
  if change_class
    b1 = feval(class_of_a,b1);
  end
  
  %If input is not complex, the output should not be complex. COMPLEX always
  %creates an imaginary part even if the imaginary part is zeros.
  if isreal(hcol)
    % b will always be real
    b = b1;
  elseif isreal(b_row_applied)
    % b1 and b2 will always be real. b will always be complex
    b = complex(b1,b2);
  else
    % b1 and/or b2 may be complex.  b will always be complex
    b = complex(imsubtract(real(b1),imag(b2)),imadd(imag(b1),real(b2)));
  end

else % non-separable filter case
  
  % Create connectivity matrix.  Only use nonzero values of the filter.
  conn_logical = h~=0;
  conn = double( conn_logical );  %input to the mex file must be double
  
  nonzero_h = h(conn_logical);
  
  % Separate real and imaginary parts of the filter (h) in the M-code and
  % filter imaginary and real parts of the image (a) in the mex code. 
  checkMexFileInputs(a,im_size,real(h),real(nonzero_h),conn,start,flags);
  b1 = imfilter_mex(a,im_size,real(h),real(nonzero_h),conn,start,flags);
  
  if ~isreal(h)
    checkMexFileInputs(a,im_size,imag(h),imag(nonzero_h),conn,start,flags);
    b2 = imfilter_mex(a,im_size,imag(h),imag(nonzero_h),conn,start,flags);
  end
  
  %If input is not complex, the output should not be complex. COMPLEX always
  %creates an imaginary part even if the imaginary part is zeros.
  if isreal(h)
    % b will always be real
    b = b1;
  elseif isreal(a)
    % b1 and b2 will always be real. b will always be complex
    b = complex(b1,b2);
  else
    % b1 and/or b2 may be complex.  b will always be complex
    b = complex(imsubtract(real(b1),imag(b2)),imadd(imag(b1),real(b2)));
  end
end

%======================================================================

function [a,h,boundary,flags ] = parse_inputs(a,h,varargin)

iptchecknargin(2,5,nargin,mfilename);

iptcheckinput(a,{'numeric' 'logical'},{'nonsparse'},mfilename,'A',1);
iptcheckinput(h,{'double'},{'nonsparse'},mfilename,'H',2);

%Assign defaults
flags = 0;
boundary = 0;  %Scalar value of zero
output = 'same';
do_fcn = 'corr';

allStrings = {'replicate', 'symmetric', 'circular', 'conv', 'corr', ...
              'full','same'};

for k = 1:length(varargin)
  if ischar(varargin{k})
    string = iptcheckstrs(varargin{k}, allStrings,...
                          mfilename, 'OPTION',k+2);
    switch string
     case {'replicate', 'symmetric', 'circular'}
      boundary = string;
     case {'full','same'}
      output = string;
     case {'conv','corr'}
      do_fcn = string;
    end
  else
    iptcheckinput(varargin{k},{'numeric'},{'nonsparse'},mfilename,'OPTION',k+2);
    boundary = varargin{k};
  end %else
end

if strcmp(output,'full')
  flags = bitor(flags,8);
elseif strcmp(output,'same');
  flags = bitor(flags,4);
end

if strcmp(do_fcn,'conv')
  flags = bitor(flags,2);
elseif strcmp(do_fcn,'corr')
  flags = bitor(flags,0);
end


%--------------------------------------------------------------
function checkMexFileInputs(varargin)
% a
a = varargin{1};
iptcheckinput(a,{'numeric' 'logical'},{'nonsparse'},mfilename,'A',1);

% im_size
im_size = varargin{2};
if ~strcmp(class(im_size),'double') || issparse(im_size)
  displayInternalError('im_size');
end

% h
h = varargin{3};
if ~isa(h,'double') || ~isreal(h) || issparse(h)
  displayInternalError('h');
end

% nonzero_h
nonzero_h = varargin{4};
if ~isa(nonzero_h,'double') || ~isreal(nonzero_h) || ...
      issparse(nonzero_h)
  displayInternalError('nonzero_h');
end

% start
start = varargin{6};
if ~strcmp(class(start),'double') || issparse(start)
  displayInternalError('start');
end

% flags
flags = varargin{7};
if ~isa(flags,'double') ||  any(size(flags) ~= 1)
  displayInternalError('flags');
end

%--------------------------------------------------------------
function displayInternalError(string)

eid = sprintf('Images:%s:internalError',mfilename);
msg = sprintf('Internal error: %s is not valid.',upper(string));
error(eid,'%s',msg);