function contrastMask = filterLowContrast(objectImages, thres)
% Input:
%  objectImages: w x h x t array containily a fast scan
%  thres: min threshold of contrast for processing pixels (uint8 array: 30,
%         double array: 0.1176
% Output:
%  contrastMask: w x h logical array, 0 signifying the pixel has too low
%                contrast and 1 otherwise

if nargin < 2
    if isinteger(objectImages)
        thres = 30;
    end
    if isfloat(objectImages)
        thres = 0.1176;
    end
end

Imin = min(objectImages,[],3);
Imax = max(objectImages,[],3);
contrastMask = (Imax-Imin)>thres;

end