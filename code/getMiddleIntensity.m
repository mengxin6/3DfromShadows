function Imiddle = getMiddleIntensity(objectImages)
% Input:
%  objectImages: h x w x t array
% Output:
%  Imiddle: h x w array, 'middle value' of each pixel in objectImages across
%  time
Imin = min(objectImages, [],3);
Imax = max(objectImages,[],3);
Imiddle = 0.5*Imax + 0.5*Imin;
end
