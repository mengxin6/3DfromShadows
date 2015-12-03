% Main Routine of the 3D from Shadows System
% Author: Mengxin Li, Yi Hua
% Carnegie Mellon University 

%% Load data
% checkerImgNames = {'../data/sample/calibration/camera-calibration1.pgm', ...
%     '../data/sample/calibration/camera-calibration2.pgm'};
% lightImgNames = {'../data/sample/calibration/light-calibration1.pgm', ...
%     '../data/sample/calibration/light-calibration2.pgm',...
%     '../data/sample/calibration/light-calibration3.pgm',...
%     '../data/sample/calibration/light-calibration4.pgm'};
%     % objectImages: H x W x N matrix
% objectImagePaths=createObjectImagePaths();
% for i=1:size(objectImagePaths,2)
%     objectImages(:,:,i)=imread(objectImagePaths{1,i});
% end    
% checkerSquareSizeInMM = 23;
% pencilLenInMM = 76;
% loadPtsFrom = '../data/sample/lightCalib';
% margin=0.15;

checkerImgNames = {'../data/1202robolounge/camera/c1.jpg',...
    '../data/1202robolounge/camera/c2.jpg',...
    '../data/1202robolounge/camera/c3.jpg',...
    '../data/1202robolounge/camera/c4.jpg'...
    '../data/1202robolounge/camera/c5.jpg',...
    '../data/1202robolounge/camera/c6.jpg',...
    '../data/1202robolounge/camera/c7.jpg',...
    '../data/1202robolounge/camera/c8.jpg'...
    '../data/1202robolounge/camera/c9.jpg'};
lightImgNames = {'../data/1202robolounge/light/l1.jpg',...
    '../data/1202robolounge/light/l2.jpg',...
    '../data/1202robolounge/light/l3.jpg',...
    '../data/1202robolounge/light/l4.jpg',...
    '../data/1202robolounge/light/l5.jpg'};
% objectImages: H x W x N matrix
objectImages = [];
objectImagePaths=createObjectImagePaths();
for i=1:size(objectImagePaths,2)
%     objectImages(:,:,i)=imread(objectImagePaths{1,i});
    objectImages(:,:,i)=rgb2gray(imread(objectImagePaths{1,i}));
end    
checkerSquareSizeInMM = 23;
pencilLenInMM = 141;
% loadPtsFrom = '../data/sample/lightCalib';
margin=0.15

%% Calibrate camera and desk plane
% camParams: matlab cameraParameters structure
% horizontalPlane: 4x1 vector
[camParams, horizontalPlane] = calibrateCameraGroundPlane(...
    checkerImgNames, checkerSquareSizeInMM);

%% Calibrate light source location
% lightLoc: 3x1 vector
% lightLoc = inferLightSourceLocation(lightImgNames, camParams, pencilLenInMM, loadPtsFrom);
lightLoc = inferLightSourceLocation(lightImgNames, camParams, pencilLenInMM);


%% 3D from scan
for i = 1:size(objectImagePaths, 2)
    objectImages(:,:,i) = undistortImage(objectImages(:,:,i), camParams);
end
spatialEdge=findSpatialEdge(objectImages);
edgeLine=edgeLineFitting(spatialEdge);
[imHeight,imWidth]=size(objectImages(:,:,1));
objpts = getObjectPts(spatialEdge,edgeLine,[imHeight*margin, ...
    imHeight*(1-margin),imWidth*margin,imWidth*(1-margin)]);
shadowPlanePts = getShadowPlane(edgeLine, lightLoc, camParams, ...
    size(objectImages,2), size(objectImages,1));
% TODO: compute linear interpolation
object3dpts = triangulate(objpts, shadowPlanePts, camParams);
draw3dObject(object3dpts);


%% Merge scans (if multiple scans were made)
% TODO
