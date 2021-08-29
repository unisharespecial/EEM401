function [s,t] = cosineGenerator(A,f,sFreq,npts,phase) 
% Usage: [s,t] = cosineGenerator(A,f,sFreq,npts,[phase=0]) 
%Function returns a time vector t and the corresponding harmonic (cos) wave s 
%of length npts with amplitude A and frequency f [Hz], 
%sampled at frequency sFreq[Hz or samples per second]. 
%The argument 'phase' is in degrees and is optional. When the phase is omitted 
%it is assumed that the phase is zero. For a sine use phase=-90. 
%When no LHS arguments are used (nargout is 0) the sgnal is plotted. 
 
if nargin == 4, 
 phase = 0; 
elseif nargin < 4 || nargin > 5, 
 help cosineGenerator 
 error('Incorrect use of the function'); 
end 
%convert phase to radians 
phase = phase / 180 * pi; 
%sampling interval 
dt = 1 / sFreq; 
%generate the time vector 
t = (0:npts-1)' .* dt; 
%generate the wave 
s = A .* cos(2 * pi * f .* t + phase); 
%plot if no values are to be returned 
if nargout == 0 
 subplot(2,1,1) 
 plot(t,s) 
 v=axis; 
 v(2)=t(end); 
 axis(v) 
 grid on 
 xlabel('Time [s]') 
 ylabel('Units') 
 title('Signal') 
 subplot(2,1,2) 
 pts2plot = 20; 
 plot(t(1:pts2plot),s(1:pts2plot),'o-') 
 v=axis; 
 v(2)=t(pts2plot); 
 axis(v) 
 grid on 
 xlabel('Time [s]') 
 ylabel('Units') 
end 
