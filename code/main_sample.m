% Main Routine of the 3D from Shadows System
% Author: Mengxin Li, Yi Hua
% Carnegie Mellon University 

clc; clear all;

%% Load data
checkerImgNames = {'../data/sample/calibration/camera-calibration1.pgm', ...
    '../data/sample/calibration/camera-calibration2.pgm'};
lightImgNames = {'../data/sample/calibration/light-calibration1.pgm', ...
    '../data/sample/calibration/light-calibration2.pgm',...
    '../data/sample/calibration/light-calibration3.pgm',...
    '../data/sample/calibration/light-calibration4.pgm'};
% objectImages: H x W x N matrix
nmax = 40;
nmin = 1;
objectImagePaths=cell(1,nmax-nmin+1);
for n=nmin:nmax
    objectImagePaths{1,n}=strcat('../data/sample/bottle/','bottle',num2str(n-1,'%03i'),'.pgm');
end
objectImages = [];
for i=1:size(objectImagePaths,2)
    objectImages(:,:,i)=im2double(imread(objectImagePaths{1,i}));
end    
checkerSquareSizeInMM = 23;
pencilLenInMM = 76;
loadPtsFrom = '../data/sample/lightCalib.mat';
margin=70;

addpath('/Users/hawaiii/Developer/TOOLBOX_calib');
%% Calibrate camera and desk plane
% camParams: matlab cameraParameters structure
% horizontalPlane: 4x1 vector
[camParams, camTrans, camRot] = calibrateCameraGroundPlane(...
    checkerImgNames, checkerSquareSizeInMM);

%% Calibrate light source location
% lightLoc: 3x1 vector
lightLoc = inferLightSourceLocation(lightImgNames, camParams, camTrans, camRot, ...
    pencilLenInMM, loadPtsFrom);

%% 3D from scan
for i = 1:size(objectImagePaths, 2)
    objectImages(:,:,i) = undistortImage(objectImages(:,:,i), camParams);
end
IcontrastMask = filterLowContrast(objectImages);
Imiddle = getMiddleIntensity(objectImages);

prevIm = objectImages(:,:,1).*IcontrastMask;
prevShadowPlane = []; % TODO
object3dpts = [];
for f = 2:size(objectImagePaths,2)
    curIm = objectImages(:,:,f).*IcontrastMask;
    spatialEdge = findSpatialEdge(prevIm-Imiddle, curIm-Imiddle);
    spatialEdge([1:margin, end-margin:end],:) = 0;
    objpts = spatialEdge;
    shadowPlanePts = getShadowPlane(spatialEdge, lightLoc, camParams, ...
        camTrans, camRot);
    object3dpts = [object3dpts triangulate(objpts, shadowPlanePts, prevShadowPlane, ...
            camParams, camTrans, camRot)];
   
    prevIm = curIm;
%     prevShadowPlane = shadowPlanePts;
end
draw3dObject(object3dpts);

% spatialEdge=findSpatialEdge(objectImages);
% edgeLine=edgeLineFitting(spatialEdge);
% [imHeight,imWidth]=size(objectImages(:,:,1));
% objpts = getObjectPts(spatialEdge,edgeLine,[imHeight*margin, ...
%     imHeight*(1-margin),imWidth*margin,imWidth*(1-margin)]);
% shadowPlanePts = getShadowPlane(edgeLine, lightLoc, camParams, camTrans, camRot, ...
%     size(objectImages,2), size(objectImages,1));
% % TODO: compute linear interpolation
% object3dpts = triangulate(objpts, shadowPlanePts, camParams, camTrans, camRot);
% draw3dObject(object3dpts);


%% Merge scans (if multiple scans were made)
% TODO
