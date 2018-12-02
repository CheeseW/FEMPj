clear
clc
%% load data and visualize 
filename = 'q9single';
[nodes, els, mats, ndof, d] = parseInput(filename);
VisualiseMesh(nodes, els(:,1:5),[],'e','b');
hold off

%% assemble stiffness matrix
% 
% nnodes = size(nodes,1);
% nels   = size(els,1);
% nnpe   = size(els,2)-1;
% nmats  = size(mats,1);
% 
% K = sparse(nnodes*ndof,nnodes*ndof);
% 
% for i=1:nels
%     X = zeros(d,nnpe);
%     el = els(i,:);
%     for j=1:nnpe
%         X(:,j) = nodes(el(j+1),:)';
%     end
%     R = localSTF(X, mats(i,:)); 
%     idx = [el(2:end)*2-1; el(2:end)*2];
%     idx = reshape(idx,1,nnpe*ndof);
%     symR = sum(R,3);
%     symR = (symR+symR')/2;
%     K(idx,idx) = K(idx,idx)+symR;
% end
% 
% T = importdata('tmat');
% dp2 = length(T)/18/18;
% T = reshape(T,[18,18,dp2]);
% W = importdata('wmat');
% W = reshape(W,[18,3]);
% % max(max(max(abs(R-T)./abs(R))))
% % eig(sum(R,3))
% % eig(sum(T,3))