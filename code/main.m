% Main Routine of the 3D from Shadows System
% Author: Mengxin Li, Yi Hua
% Carnegie Mellon University 


clc; clear all;

% addpath('/Users/hawaiii/Developer/TOOLBOX_calib');
addpath('debug/');

%% Load data
% checkerImgNames = {'../data/1202night2/camera/c5.jpg',...
%     '../data/1202night2/camera/c6.jpg',...
%     '../data/1202night2/camera/c7.jpg'};
% lightImgNames = {'../data/1202night2/light_u/1_rect.jpg',...
%     '../data/1202night2/light_u/2_rect.jpg',...
%     '../data/1202night2/light_u/3_rect.jpg',...
%     '../data/1202night2/light_u/4_rect.jpg',...
%     '../data/1202night2/light_u/5_rect.jpg'};
lightImgNames = {'../data/1202night2/light/1.jpg',...
    '../data/1202night2/light/2.jpg',...
    '../data/1202night2/light/3.jpg',...
    '../data/1202night2/light/4.jpg',...
    '../data/1202night2/light/5.jpg'};
% objectImages: H x W x N matrix
nmax = 57;
nmin = 1;
objectImagePaths=cell(1,nmax-nmin+1);
for n=nmin:nmax
      objectImagePaths{1,n-nmin+1}=strcat('../data/1202night2/mug32/',num2str(n),'.jpg');
%     objectImagePaths{1,n-nmin+1}=strcat('../data/1202night2/mug32_u/',num2str(n),'_rect.jpg');
end
objectImages = [];
for i=1:size(objectImagePaths,2)
    I = im2double(imread(objectImagePaths{1,i}));
    if size(I,3) > 1
        objectImages(:,:,i) = rgb2gray(I);
    else
        objectImages(:,:,i) = I;
    end
end    
checkerSquareSizeInMM = 23;
pencilLenInMM = 112;
loadPtsFrom = '../data/1202night2/lightcalib.mat';
topmargin = 0;
botmargin=150;

%% Calibrate camera and desk plane
% camParams: matlab cameraParameters structure
% horizontalPlane: 4x1 vector
load('../data/1202night2/cameraParams1202N.mat');
camParams = cameraParams;
camRot = camParams.RotationMatrices;
camTrans = camParams.TranslationVectors;
camCenter = -inv(camRot')*camTrans';
% [camParams, camTrans, camRot] = calibrateCameraGroundPlane(...
%     checkerImgNames, checkerSquareSizeInMM);

%% Calibrate light source location
% lightLoc: 3x1 vector
lightLoc = inferLightSourceLocation(lightImgNames, camParams, camTrans, camRot, ...
    pencilLenInMM, loadPtsFrom,0);

%% 3D from scan
% for i = 1:size(objectImagePaths, 2)
%     objectImages(:,:,i) = undistortImage(objectImages(:,:,i), camParams);
% end
IcontrastMask = filterLowContrast(objectImages);
Imiddle = getMiddleIntensity(objectImages);

prevIm = objectImages(:,:,1).*IcontrastMask;
prevShadowPlane = [];
object3dpts = [];
for f = 2:size(objectImagePaths,2)
    curIm = objectImages(:,:,f).*IcontrastMask;
    spatialEdge = findSpatialEdge(prevIm-Imiddle, curIm-Imiddle);
    spatialEdge([1:topmargin, end-botmargin:end],:) = 0;
    objpts = spatialEdge;
    shadowPlanePts = getShadowPlane(spatialEdge, lightLoc, camParams, ...
        camTrans, camRot, curIm);
    object3dpts = [object3dpts triangulate(objpts, shadowPlanePts, prevShadowPlane, ...
            camParams, camTrans, camRot, camCenter)];
   
    prevIm = curIm;
    prevShadowPlane = shadowPlanePts;

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
