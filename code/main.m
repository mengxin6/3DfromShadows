% Main Routine of the 3D from Shadows System
% Author: Mengxin Li, Yi Hua
% Carnegie Mellon University 

%% Load data
checkerImgNames = {'../data/sample/calibration/camera-calibration1.pgm', '../data/sample/calibration/camera-calibration2.pgm'};

%% Calibrate camera and desk plane
% camParams: matlab cameraParameters structure
% horizontalPlane: 4x1 vector
[camParams, horizontalPlane] = calibrateCameraGroundPlane(...
    checkerImgNames, 23);

%% Calibrate light source location
% TODO

%% 3D from scan
% TODO

%% Merge scans (if multiple scans were made)
% TODO