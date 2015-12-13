function [camParams, camTrans, camRot] = calibrateCameraGroundPlane(...
    imNames, squareSizeInMM)
% Input:
%  imNames is a cell array containing a string that specifies the full path
%  to a image.
% Output:
%  camParams: matlab cameraParameters structure
%  camTrans: 1x3
%  camRot: 3x3 matrix

% imagePoints is an M-by-2-by-numImages array of x-y coordinates
% boardSize specifies the checkerboard dimensions as [rows, cols] measured insquares.
[imagePoints, boardSize] = detectCheckerboardPoints(imNames);

% an M x 2 matrix containing the x-y coordinates of the corners of squares
%  of a checkerboard.
worldPoints = generateCheckerboardPoints(boardSize,squareSizeInMM);

% Camera Params
camParams = estimateCameraParameters(imagePoints,worldPoints);
% showReprojectionErrors(camParams);
% figure;
% imshow(imageFileNames{1});
% hold on;
% plot(imagePoints(:,1,1), imagePoints(:,2,1),'go');
% plot(camParams.ReprojectedPoints(:,1,1), camParams.ReprojectedPoints(:,2,1),'r+');
% legend('Detected Points','ReprojectedPoints');
% hold off;
meanReprojError = reshape(mean(mean(camParams.ReprojectionErrors.^2,1),2),size(imNames,2),[]);
[~,bestBoard] = min(meanReprojError);
camTrans = camParams.TranslationVectors(bestBoard,:);
camRot = camParams.RotationMatrices(:,:,bestBoard);

% Calculate the coordinate vector of the ground plane (plane of the checker
% board)
% A = [worldPoints(:,1)-mean(worldPoints(:,1)), worldPoints(:,2)-mean(worldPoints(:,2)), zeros(size(worldPoints,1),1)];
% [~,~,V]=svd(A,0);
% d = 0 - [worldPoints(1,:), 0]*V(:,end);
% horizontalPlane=vertcat(V(:,end), d);

end

