function point = linePlaneIntersection(linepts, planepts)
% Input:
%  linepts: 3x2 matrix, each column is a 3D point
%  planepts: 3x3 matrix, each column is a 3D point
% Output:
%  point: 3x1, a 3D point where the plane intersect the line
A = vertcat(ones(1,4), [planepts, linepts(:,1)]);
B = [vertcat(ones(1,3), planepts),vertcat(zeros(1,1), linepts(:,2)-linepts(:,1))];
t = -det(A)/det(B);
point = linepts(:,1) + ((linepts(:,2)-linepts(:,1))*t);

end