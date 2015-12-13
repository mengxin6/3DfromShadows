function draw3dObject(object3dpts, objectcolor)
% Input:
%  object3dpts:
%  objectcolor:
% Output:
%  (plots the 3D image)

if nargin < 2
    object3dpts = object3dpts(:,object3dpts(3,:)>=0); %discard points below plane
    figure;
    scatter3(object3dpts(1,:),object3dpts(2,:),object3dpts(3,:),'filled'); 
    xlim([min(object3dpts(1,:)) max(object3dpts(1,:))]);
    ylim([min(object3dpts(2,:)) max(object3dpts(2,:))]);
    zlim([0 max(object3dpts(3,:))]);
    xlabel('x');ylabel('y');zlabel('z');
else
    
    objectcolor = objectcolor(:,object3dpts(3,:)>=0); %discard points
    object3dpts = object3dpts(:,object3dpts(3,:)>=0); %discard points below plane

    figure; 
    scatter3(object3dpts(1,:)',object3dpts(2,:)',object3dpts(3,:)',[], objectcolor','filled'); 
    xlim([min(object3dpts(1,:)) max(object3dpts(1,:))]);
    ylim([min(object3dpts(2,:)) max(object3dpts(2,:))]);
    zlim([0 max(object3dpts(3,:))]);
    xlabel('x');ylabel('y');zlabel('z');
% hold on;
end