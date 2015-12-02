function draw3dObject(object3dpts)
allPoints=[];
for i=1:size(object3dpts,2)
    allPoints=[allPoints,object3dpts{i}];
end
figure; scatter3(allPoints(1,:),allPoints(2,:),allPoints(3,:),'filled'); hold on;
end