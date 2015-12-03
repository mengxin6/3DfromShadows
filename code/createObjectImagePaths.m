function objectImagePaths=createObjectImagePaths()
objectImagePaths=cell(1,81);
for n=1:81
%     objectImagePaths{1,n}=strcat('../data/sample/bottle/','bottle',num2str(n-1,'%03i'),'.pgm');
    objectImagePaths{1,n}=strcat('../data/1202robolounge/duck6/',num2str(n),'.jpg');
end
