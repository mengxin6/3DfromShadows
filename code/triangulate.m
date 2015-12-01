function [object3dpts] = triangulate(object2dpts, shadowPlanePts, cameraParams)
% Input:
%  objpts: 1x(nframes-1) cell array, where cell i contains 2xKi matrix,
%          denoting points on the image that are on the object to be
%          scanned.
%  shadowPlanePts: 9x(nframes-1) matrix; each column is 
%                  [x1 y1 z1 x2 y2 z2 lx ly lz] that specifies 3 points on 
%                  the shadow plane
%  cameraParms: a cameraParams structure returned by matlab
% Output:
%  object3dpts: 1x(nframes-1) cell array, where cell i contains 3xKi matrix,
%               denoting 3d points on the object to be scanned.

N = size(object2dpts, 2);
object3dpts = cell(1,N);
camCenter = mean(cameraParams.TranslationVectors,1)'; %3x1
for i = 1:N
    rays = pointsToWorld(cameraParams, mean(cameraParams.RotationMatrices,3),...
   mean(cameraParams.TranslationVectors,1), object2dpts{1,i}'); %Nx2
    
    K = size(rays,1);
    pts3d = zeros(3, K);
    for j = 1:K
        pts3d(:,j) = linePlaneIntersection([rays(j,:)' camCenter],...
            shadowPlanePts(:,i));
    end
    object3dpts{1,i} = pts3d;
end

end