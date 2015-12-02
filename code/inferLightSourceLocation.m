function [lightLoc] = inferLightSourceLocation(imNames, cameraParams, pencilLenInMM, loadPtsFrom)
% Input:
%  imNames, a 1xN cell matrix containing strings of light calibration images
%  cameraParams: a cameraParameters structure
%  pencilLenInMM: length of pencil in mm.
%  loadPtsFrom: string, path to load b and ts from, optional
% Output:
%  3x1 vector describing the location of point light source
N = size(imNames,2);
if nargin < 4

    % Get point b and ts
    b = zeros(N,2);
    ts = zeros(N,2);
    idx = 1;
    for i = imNames
        f = figure(1);
        J = undistortImage(imread(i{1}), cameraParams);
        imshow(J); title('Click on bottom of pencil and press enter')
        [bx, by] = getpts(f);
        b(idx,1) = bx(end); b(idx,2) = by(end);
        idx = idx+1;
    end
    idx = 1;
    for i = imNames
        f = figure(1);
        J = undistortImage(imread(i{1}), cameraParams);
        imshow(J); title('Click on top of shadow and press enter')
        [tsx, tsy] = getpts(f);
        ts(idx,1) = tsx(end); ts(idx,2) = tsy(end);
        idx = idx+1;
    end
else
    load(loadPtsFrom);
end

% Infer B, Ts in 3D
B = pointsToWorld(cameraParams, mean(cameraParams.RotationMatrices,3),...
   mean(cameraParams.TranslationVectors,1), b);
B = [B zeros(N,1)];
Ts = pointsToWorld(cameraParams, mean(cameraParams.RotationMatrices,3),...
   mean(cameraParams.TranslationVectors,1), ts);
Ts = [Ts zeros(N,1)];

% Infer T from pencil length
T = B + [zeros(N,2) repmat(pencilLenInMM, N, 1)];

% Infer line on which point light source lies
ln = normr(Ts - T);
lightLoc = linesIntersectionPoint(T, ln);
end