function [objpts3d] = triangulate(objpts, shadowPlanePts, prevShadowPlane, ...
        camParams, camTrans, camRot)
% Input:
%  objpts: h x w double, non-zero value specifying the sub-frame time 
%          between previous and current image that the shadow edge hit
%          this pixel (0: no shadow, (0,1): sometime between previous
%          and current frame, 1: current frame)
%  shadowPlanePts: 3x3 matrix containg 3 3D points on the current shadow
%                  plane (in column)
%  prevShadowPlane: similar to shadowPlanePts, but specifies the shadow
%                   plane in the previous frame
%  camParams: MATLAB camera paramters structure 
%  camTrans: camera translation vector
%  camRot: camera rotation vector
% Output:
%  objpts3d: 3xN matrix where each column specifies a 3D point

% interpolate shadow plane
[y, x] = find(objpts > 0 & objpts <= 1);
N = size(y,1);

if size(shadowPlanePts,1) ~= 3
    objpts3d = [];
    return;
end

if size(prevShadowPlane, 1) < 3 % prevShadowPlane might be empty
    interShadows = repmat(shadowPlanePts, 1, 1, N);
else
    timevals = zeros(3,3,N);
    for i = 1:N
        timevals(:,:,i) = objpts(y(i),x(i));
    end
    interShadows = timevals.*repmat(shadowPlanePts,1,1,N) + ...
        (ones(size(timevals))-timevals).*repmat(prevShadowPlane,1,1,N);
end

% scatter3(shadowPlanePts(1,:), shadowPlanePts(2,:), shadowPlanePts(3,:));
% hold on
% scatter3(prevShadowPlane(1,:), prevShadowPlane(2,:), prevShadowPlane(3,:));
% scatter3(interShadows(1,:), interShadows(2,:), interShadows(3,:));

rays = pointsToWorld(camParams, camRot, camTrans, [x y]);
rays = [rays, zeros(N,1)];

% Triagulate by plane-line intersection
objpts3d = zeros(3, N);
for i = 1:N
    objpts3d(:,i) = linePlaneIntersection([rays(i,:)' camTrans'], ...
        interShadows(:,:,i));
end

% figure;
% hold on
% scatter3(camTrans(1), camTrans(2), camTrans(3))
% zlabel('z')
% for j = 1:size(rays,1)
% 	line([rays(j,1) camTrans(1)],[rays(j,2) camTrans(2)], [rays(j,3) camTrans(3)]);
% 	patch(interShadows(1,:,j), interShadows(2,:,j), interShadows(3,:,j),'y','FaceAlpha',0.5);
% 	scatter3(objpts3d(1,j), objpts3d(2,j), objpts3d(3,j),'filled');
% end




end