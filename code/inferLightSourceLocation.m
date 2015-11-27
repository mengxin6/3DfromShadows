function [lightLoc] = inferLightSourceLocation(imNames, cameraParams, pencilLenInMM)
% Input:
%  imNames, a 1xN cell matrix containing strings of light calibration images
%  cameraParams: a cameraParameters structure
%  pencilLenInMM: length of pencil in mm.
% Output:
%  3x1 vector describing the location of point light source

% Get point b and ts
N = size(imNames,2);
b = zeros(N,2);
ts = zeros(N,2);
idx = 1;
for i = imNames
    f = imshow(imread(imNames{i})); title('Click on bottom of pencil and press enter')
    [bx, by] = getpts(f);
    b(idx,1) = bx(1); b(idx,2) = by(1);
    f = imshow(imread(imNames{i})); title('Click on top of shadow and press enter')
    [tsx, tsy] = getpts(f);
    ts(idx,1) = tsx(1); ts(idx,2) = tsy(1);
    idx = idx+1;
end

% Infer B, Ts in 3D
B = pointsToWorld(cameraParams, mean(cameraParams.RotationVectors,1),...
   mean(cameraParams.TranslationVectors,1), b);
Ts = pointsToWorld(cameraParams, mean(cameraParams.RotationVectors,1),...
   mean(cameraParams.TranslationVectors,1), ts);

% Infer T from pencil length
T = Ts + repmat(pencilLenInMM, N, 3);

% Infer line on which point light source lies
% TODO

end