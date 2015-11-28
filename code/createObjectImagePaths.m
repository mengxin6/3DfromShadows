function objectImagePaths=createObjectImagePaths()
objectImagePaths=cell(1,40);
for n=1:40
    objectImagePaths{1,n}=strcat('../data/sample/bottle/','bottle',num2str(n-1,'%03i'),'.pgm');
end
