% Main Routine of the 3D from Shadows System
% Author: Mengxin Li, Yi Hua
% Carnegie Mellon University 

%% Load data
checkerImgNames = {'../data/sample/calibration/camera-calibration1.pgm', ...
    '../data/sample/calibration/camera-calibration2.pgm'};
lightImgNames = {'../data/sample/calibration/light-calibration1.pgm', ...
    '../data/sample/calibration/light-calibration2.pgm',...
    '../data/sample/calibration/light-calibration3.pgm',...
    '../data/sample/calibration/light-calibration4.pgm'};
    % objectImages: H x W x N matrix
objectImagePaths=createObjectImagePaths();
for i=1:size(objectImagePaths,2)
    objectImages(:,:,i)=imread(objectImagePaths{1,i});
end    
checkerSquareSizeInMM = 23;
pencilLenInMM = 76;

%% Calibrate camera and desk plane
% camParams: matlab cameraParameters structure
% horizontalPlane: 4x1 vector
[camParams, horizontalPlane] = calibrateCameraGroundPlane(...
    checkerImgNames, checkerSquareSizeInMM);

%% Calibrate light source location
% lightLoc: 3x1 vector
lightLoc = inferLightSourceLocation(lightImgNames, camParams, pencilLenInMM);

%% 3D from scan
spatialEdge=findSpatialEdge(objectImages);
edgeLine=edgeLineFitting(spatialEdge);
shadowPlanePts = getShadowPlane(edgeLine, lightLoc, cameraParams);



%% Merge scans (if multiple scans were made)
% TODO
