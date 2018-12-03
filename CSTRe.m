function re = CSTRe(nodes, BdrIdx, st)
% re = CSTRe(nodes, BdrIdx, st)
% function for compute consistent nodal load
% for CST mesh under the following condition
% uniform stress on boundary that is horizontal
% and straight
% nodes  - the nodes parsed from input file
% BdrIdx - the node number of nodes on the boundary
% st     - the stress on the boundary
% re     - resulted nodal force
%        - lbdr x 2 : [node# force]
% TODO: create one that deal with more complicated 
% traction and geometry

lelb = 2;

lbdr = length(BdrIdx);
BdrIdx = reshape(BdrIdx,lbdr,1);
re = zeros(lbdr,2);
re(:,1) = BdrIdx;
left  = 1:lelb-1:lbdr-1;
right = 2:lelb-1:lbdr;

consist = [1 1];
consist = consist/sum(consist);
lel = nodes(BdrIdx(right),1)-nodes(BdrIdx(left),1);
fel = lel*consist;
re(left,2)  = re(left,2)+fel(:,1);
re(right,2) = re(right,2)+fel(:,2);
end