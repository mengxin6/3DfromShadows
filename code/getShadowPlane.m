function [shadowPlanePts] = getShadowPlane(edgeLine, lightLoc, cameraParams, camTrans, camRot, xmax, ymax)
% Calculates the shadow plane by finding 2 3d points on the intersection of 
% shadow plane and horizontal plane.
% Input:
%  edgeLine: 3xn matrix where n is the number of frames from the scan;
%              each column is [a b c]' that specifies line ax+by+c=0
%  lightLoc: 3x1 vector specifying the location of light source
%  cameraParams: a camera parameter structure
%  xmax: size of scan image in horizontal dimension
% Output:
%  shadowPlanePts: 9xn matrix where n is the number of frames from the
%                  scan; each column is [x1 y1 z1 x2 y2 z2 lx ly lz] that 
%                  specifies 3 points on the shadow plane

N = size(edgeLine,2);
edgeLine2d = zeros(4,N);
% find intersection of this line with the image boarder
% intersecting with top & bottom boarder
nonhorizontal = edgeLine(1,:)~=0;
edgeLine2d(1,nonhorizontal) = round((-edgeLine(3,nonhorizontal)-edgeLine(2,nonhorizontal)*1)./edgeLine(1,nonhorizontal));
edgeLine2d(2,nonhorizontal) = 1;
edgeLine2d(3,nonhorizontal) = round((-edgeLine(3,nonhorizontal)-edgeLine(2,nonhorizontal)*ymax)./edgeLine(1,nonhorizontal));
edgeLine2d(4,nonhorizontal) = ymax;
% intersecting with right & left boarder
horizontal = (edgeLine(1,:)==0 | edgeLine2d(1,:)<1 | edgeLine2d(1,:)>xmax ...
    | edgeLine2d(3,:) < 1 | edgeLine2d(3,:) >xmax); % assuming if a=0 then b~=0
edgeLine2d(1,horizontal) = 1;
edgeLine2d(2,horizontal) = round((-edgeLine(3,horizontal)-edgeLine(1,horizontal)*1)./edgeLine(1,horizontal));
edgeLine2d(3,horizontal) = xmax;
edgeLine2d(4,horizontal) = round((-edgeLine(3,horizontal)-edgeLine(1,horizontal)*xmax)./edgeLine(1,horizontal));

% project points
pts3d = pointsToWorld(cameraParams, camRot,...
   camTrans, reshape(edgeLine2d,2,[])');
shadowPlanePts = zeros(9,N);
shadowPlanePts(1:2,:) = pts3d(1:2:2*N, :)';
shadowPlanePts(4:5,:) = pts3d(2:2:2*N, :)';
shadowPlanePts(7:9,:) = repmat(lightLoc,1,N);

end