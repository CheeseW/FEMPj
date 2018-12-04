clear
clc
%% different settings
problems = {struct('file','q9single','corners',1:4)
            struct('file','cstdata', 'corners',1:3)
    };
%% load data and get parameters 
% input
filename = 'q9patch';
corners  = problems{1}.corners;
[nodes, els, mats, BC, ndof, d] = parseInput(filename);
nnodes = size(nodes,1);
nels   = size(els,1);
nnpe   = size(els,2)-1;
nmats  = size(mats,1);

%% assemble stiffness matrix
K = sparse(nnodes*ndof,nnodes*ndof);
for i=1:nels
% for i=1:1
%     X = zeros(d,nnpe);
    el = els(i,:);
    X = nodes(el(2:end),:)';
%     for j=1:nnpe
%         X(:,j) = nodes(el(j+1),:)';
%     end
    R = localSTF(X, mats(el(1),:)); 
    idx = [el(2:end)*2-1; el(2:end)*2];
    idx = reshape(idx,1,nnpe*ndof);
    symR = sum(R,3);
    symR = (symR+symR')/2;
    K(idx,idx) = K(idx,idx)+symR;
end
%% create Re
Re = zeros(nnodes*ndof,1);
for i=1:ndof
    mask    = BC(:,i+1)==0;
    nmmnIdx = BC(mask,1)*ndof-ndof+i;
    Re(nmmnIdx) = Re(nmmnIdx)+BC(mask,1+ndof+i);
end
%% deal with direchlet condition
ndidx = 1:ndof*nnodes;
drchIdx = [];
drchVal = [];
for i=1:ndof
    mask = BC(:,i+1)~=0;
    drchIdx = [drchIdx; BC(mask,1)*ndof-ndof+i];
    drchVal = [drchVal; BC(mask,1+ndof+i)];    
end
ndidx(drchIdx) = [];
Re(ndidx) = Re(ndidx) - K(ndidx,drchIdx)*drchVal;

Re(drchIdx) = [];
K(drchIdx,:) = [];
K(:,drchIdx) = [];
%% solve and reformat
sol = K\Re;
result = zeros(nnodes*ndof,1);
result(drchIdx) = result(drchIdx)+drchVal;
result (ndidx) = result(ndidx)+sol;
result = reshape(result,ndof,nnodes)';
%% compute nodal stress for each element
stress = zeros(3,nnpe,nels);
for i=1:nels
    X = zeros(d,nnpe);
    el = els(i,:);
    X = nodes(el(2:end),:)';
    D = result(el(2:end),:)';
    stress(:,:,i) = elementStress(X, mats(el(1),:),D); 
end
%% others
% T = importdata('tmat');
% dp2 = length(T)/18/18;
% T = reshape(T,[18,18,dp2]);
% W = importdata('wmat');
% W = reshape(W,[18,3]);
% % max(max(max(abs(R-T)./abs(R))))
% % eig(sum(R,3))
% % eig(sum(T,3))