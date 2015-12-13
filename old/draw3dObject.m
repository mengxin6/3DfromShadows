function draw3dObject(object3dpts)
allPoints=[];
for i=1:size(object3dpts,2)
    allPoints=[allPoints,object3dpts{i}];
end
allPoints = allPoints(:,allPoints(3,:)>=0); %discard points below plane
figure; scatter3(allPoints(1,:),allPoints(2,:),allPoints(3,:),'filled'); 
xlim([min(allPoints(1,:)) max(allPoints(1,:))]);
ylim([min(allPoints(2,:)) max(allPoints(2,:))]);
zlim([0 max(allPoints(3,:))]);
xlabel('x');ylabel('y');zlabel('z');
% hold on;
end