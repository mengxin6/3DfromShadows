function objectImagePaths=createObjectImagePaths()
max = 166;
min = 20;
objectImagePaths=cell(1,max-min+1);
for n=min:max
%     objectImagePaths{1,n}=strcat('../data/sample/bottle/','bottle',num2str(n-1,'%03i'),'.pgm');
    objectImagePaths{1,n-min+1}=strcat('../data/1202night2/mug11/',num2str(n),'.jpg');
end
