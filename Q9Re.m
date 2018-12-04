function re = Q9Re(nodes, BdrIdx, st, dim)
% re = Q9Re(nodes, BdrIdx, st)
% function for compute consistent nodal load
% for Q9 mesh under the following conditino
% uniform stress on boundary that is horizontal
% and straight, the edge node of elements on 
% the boundary has to be in the middle
% nodes  - the nodes parsed from input file
% BdrIdx - the node number of nodes on the boundary
% st     - the stress on the boundary
% re     - resulted nodal force
%        - lbdr x 2 : [node# force]
% TODO: create one that deal with more complicated 
% traction and geometry

lelb = 3;

lbdr = length(BdrIdx);
BdrIdx = reshape(BdrIdx,lbdr,1);
re = zeros(lbdr,2);
re(:,1) = BdrIdx;
left  = 1:lelb-1:lbdr-2;
mid   = 2:lelb-1:lbdr-1;
right = 3:lelb-1:lbdr;

consist = [1 4 1];
consist = consist/sum(consist);
lel = nodes(BdrIdx(right),dim)-nodes(BdrIdx(left),dim);
fel = lel*consist;
re(left,2)  = re(left,2)+fel(:,1);
re(mid,2)   = re(mid,2)+fel(:,2);
re(right,2) = re(right,2)+fel(:,3);
re = re*st;
end