function [lightLoc] = inferLightSourceLocation(imNames, cameraParams, ...
    camTrans, camRot, pencilLenInMM, loadPtsFrom, undistort)
% Input:
%  imNames, a 1xN cell matrix containing strings of light calibration images
%  cameraParams: a cameraParameters structure
%  pencilLenInMM: length of pencil in mm.
%  loadPtsFrom: string, path to load b and ts from, optional
% Output:
%  3x1 vector describing the location of point light source
N = size(imNames,2);
if exist(loadPtsFrom, 'file') == 2
    load(loadPtsFrom);
else
    % Get point b and ts
    b = zeros(N,2);
    ts = zeros(N,2);
    idx = 1;
    for i = imNames
        f = figure(1);
        if undistort
            J = undistortImage(imread(i{1}), cameraParams);
        else
            J = imread(i{1});
        end
        imshow(J); title('Click on bottom of pencil and press enter')
        [bx, by] = getpts(f);
        b(idx,1) = bx(end); b(idx,2) = by(end);
        idx = idx+1;
    end
    idx = 1;
    for i = imNames
        f = figure(1);
        if undistort
            J = undistortImage(imread(i{1}), cameraParams);
        else
            J = imread(i{1});
        end
        imshow(J); title('Click on top of shadow and press enter')
        [tsx, tsy] = getpts(f);
        ts(idx,1) = tsx(end); ts(idx,2) = tsy(end);
        idx = idx+1;
    end
    save(loadPtsFrom, 'b','ts');
end

% Infer B, Ts in 3D
B = pointsToWorld(cameraParams, camRot, camTrans, b);
B = [B zeros(N,1)];
Ts = pointsToWorld(cameraParams, camRot, camTrans, ts);
Ts = [Ts zeros(N,1)];

% Infer T from pencil length
T = B + [zeros(N,2) repmat(pencilLenInMM, N, 1)];

% Infer line on which point light source lies
ln = normr(Ts - T);
lightLoc = linesIntersectionPoint(T, ln);

figure; scatter3(B(:,1), B(:,2), B(:,3)); hold on
scatter3(T(:,1), T(:,2), T(:,3));
scatter3(Ts(:,1), Ts(:,2), Ts(:,3));
for i = 1:size(Ts,1)
    line([B(i,1) Ts(i,1)],[B(i,2) Ts(i,2)],[B(i,3) Ts(i,3)]);
    line([B(i,1) T(i,1)],[B(i,2) T(i,2)],[B(i,3) T(i,3)]);
end
scatter3(lightLoc(1), lightLoc(2), lightLoc(3),'fill')

end