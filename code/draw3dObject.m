function draw3dObject(object3dpts)
object3dpts = object3dpts(:,object3dpts(3,:)>=0); %discard points below plane

% figure; 
scatter3(object3dpts(1,:),object3dpts(2,:),object3dpts(3,:),'filled'); 
xlim([min(object3dpts(1,:)) max(object3dpts(1,:))]);
ylim([min(object3dpts(2,:)) max(object3dpts(2,:))]);
zlim([0 max(object3dpts(3,:))]);
xlabel('x');ylabel('y');zlabel('z');
% hold on;
end