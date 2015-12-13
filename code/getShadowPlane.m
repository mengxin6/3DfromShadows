function [shadowPlanePts] = getShadowPlane(spatialEdge, lightLoc, camParams, ...
    camTrans, camRot, curImg)
% Computes the three points on the shadow plane on current frame, by
% fitting a line to the spatialEdge and projecting selected points to 3D.
% Input:
%  spatialEdge: h x w array containing [0,1] values; 0 means no shadow 
%               edge hitting this pixel; (0,1] meaning shadow edge hit this
%               pixel between sometime between previous frame and current
%               frame
%  lightLoc: 3x1 vector specifying the location of the light source
%  camParams: a camera parameter structure
%  camTrans: camera translation vector
%  camRot: camera rotation vector
%  curImg: current frame image, h x w, for debugging
% Output:
%  shadowPlanePts: 3x3 matrix, each column is [x,y,z]', a 3d point on the 
%                  shadow plane

% @TODO: find two points that reliably gives the shadow line on image plane
% Reliably, meaning fitting a line to a good amount of points towards the
% top and bottom of the picture
topx = 0; topy = 0;
while topx == 0 && topy < size(spatialEdge,1)*0.5
    topy = topy + 1;
    if sum(spatialEdge(topy,:)) > 0
        topx = max(find(spatialEdge(topy,:)>0));
    end
end
botx = 0; boty = size(spatialEdge,1)+1;
while botx == 0 && boty > topy
    boty = boty - 1;
    if sum(spatialEdge(boty,:)) > 0
        botx = max(find(spatialEdge(boty,:)>0));
    end
end

if nargin > 5 % debug
    plotLineFit(imfuse(spatialEdge,curImg), topx, topy, botx, boty);
end

if topx == 0 || botx == 0
    shadowPlanePts = [];
    return;
end

% Project (topx, topy), (botx, boty) to 3D
linepts = [topx, topy; botx, boty];
linepts3d = pointsToWorld(camParams, camRot, camTrans, linepts);

shadowPlanePts = [vertcat(linepts3d', zeros(1,2)), lightLoc];
   
end