function [camParams, horizontalPlane] = calibrateCameraGroundPlane(...
    imNames, squareSizeInMM)
% imNames is a cell array containing a string that specifies the full path
% to a image.

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

%% Calculate the coordinate vector of the ground plane (plane of the checker
% board)
% TODO
horizontalPlane = zeros(4,1);

end

