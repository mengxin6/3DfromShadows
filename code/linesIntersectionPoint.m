function point = linesIntersectionPoint(linept, linenormal)
% Calculates the intersection point of the lines (the point that minimizes
% sum of Euclidian distance from all lines).
% linept: Nx3, each row denotes a point on line
% linenormal: Nx3, each row is a normalized vector that specifies the
%             line's direction

N = size(linept,1);
R = zeros(3,3); q = size(3,1);
for i = 1:N
    R = R +(eye(3) - linenormal(i,:)'*linenormal(i,:));
    q = q + (eye(3) - linenormal(i,:)'*linenormal(i,:))*linept(i,:)';
end
point = R\q;

end