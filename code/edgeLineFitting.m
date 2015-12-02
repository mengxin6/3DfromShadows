function edgeLine=edgeLineFitting(spatialEdge)
% Output: 
%  edgeLine: 3xN matrix where each column are [a b c] that specifies the
%            line ax+by+c=0
numImages=size(spatialEdge,3);
numberIterate=50;
tol=1.5;
edgeLine=zeros(3,size(spatialEdge,3));
for i=1:numImages
    if(sum(sum(spatialEdge(:,:,i)))>0)
    [y,x]=find(spatialEdge(:,:,i));
    edgePoints=double([x,y]);
    edgePoints=[edgePoints,ones(size(edgePoints,1),1)];
    thr_minNumberInlier=size(edgePoints,1)/10;
    avgDistanceMin=100;
    for iteration=1:numberIterate
        randTwoPoints=edgePoints(randi(size(edgePoints,1),2,1),:);
        [U, S, V]=svd(randTwoPoints'*randTwoPoints);
        sol=U(:,end);
        dist=abs(edgePoints*sol)/sqrt(sum(sol(1:2).^2));
        inlier=edgePoints(find(dist<tol),:);
        if size(inlier,1)>thr_minNumberInlier
        [U S V]=svd(inlier'*inlier);
        sol=U(:,end);
%         twoPtsOnLine = reshape(inlier(1:2,:)',[],1);
        avgDistance=mean(abs(inlier*sol)/sqrt(sum(sol(1:2).^2)));
        if avgDistance<avgDistanceMin
            avgDistanceMin=avgDistance;
            edgeLine(:,i)=sol;
%             edgeLine(:,i) = twoPtsOnLine;
        end
    end
    end
    end
end
