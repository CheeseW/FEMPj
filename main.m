clear
clc
filename = 'q9single';
[nodes, els, mats, ndof, d] = parseInput(filename);

nnodes = size(nodes,1);
nels   = size(els,1);
nnpe   = size(els,2)-1;
nmats  = size(mats,1);

for i=1:nels
    X = zeros(d,nnpe);
    el = els(i,:);
    for j=1:nnpe
        X(:,j) = nodes(el(j+1),:)';
    end
    R = localSTF(X, mats(i,:));
end

T = importdata('tmat');
dp2 = length(T)/18/18;
T = reshape(T,[18,18,dp2]);
W = importdata('wmat');
W = reshape(W,[18,3]);
% max(max(max(abs(R-T)./abs(R))))
% eig(sum(R,3))
% eig(sum(T,3))