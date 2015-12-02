function [objpts] = getObjectPts(spatialEdge,edgeLine)
% Returns the points on the object to be scanned
% Input:
%  spatialEdge: nrow x ncol x (nframes-1) logical matrix, points on the 
%               photo that are on the shadow edge
%  edgeLine: 3x(nframes-1), where each column [a b c]' specifies the line 
%            ax+by+c=0 on image
% Output:
%  objpts: 1x(nframes-1) cell array, where cell i contains 2xKi matrix,
%          denoting points on the image that are on the object to be
%          scanned.
TOL = 10;
N = size(spatialEdge,3);
objpts = cell(1,N);
for i = 1:N
    [x,y] = find(spatialEdge(:,:,i)==1);
    mat = zeros(2,size(x,1));
    idx = 1;
    for j = 1:size(x,1)
        if abs((edgeLine(:,i))'*[x(j); y(j); 1])/sqrt(sum(edgeLine(1:2,i).^2)) > TOL
            mat(:,idx) = [x(j); y(j)];
            idx = idx+1;
        end
    end
    if idx~=1
        objpts{1,i} = mat(:,1:idx-1);
    end
end

end