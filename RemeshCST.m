clear
clc
% script for remeshing data in file 'cstdata' to q9 element
% this script depend very much on the format and meshing order in 'cstdata'
% modification maybe (and most likely) needed if applied to other files
%% generate mesh
filename = 'cstdata';
   [nodes, els, mats, BC, ndof, d] = parseInput(filename); 
   nnodes = size(nodes,1);
   nels   = size(els,1);
   nnpe   = size(els,2)-1;
   nmats  = size(mats,1);

   %rework connectivity to make q4 with center nodes first
   newEl = zeros(nels/4,9+1);
   for i=1:nels/4
        newEl(i,1) = els(i*4-4+1,1); 
        newEl(i,5+1) = els(i*4-4+1,3+1);
        for j=1:4
            nextId = mod(j,4)+1;
            newEl(i,nextId+1) = els(i*4-4+j,2+1);
            % make sure the assumption is correct
            assert(newEl(i,1) == els(i*4-4+j,1)); 
            assert(newEl(i,nextId+1)==els(i*4-4+nextId,1+1));
            assert(newEl(i,5+1)==els(i*4-4+j,3+1));
        end
   end

   newNode = zeros((nnodes-7)*2+13,d);
   % renumber the nodes that are in the mesh right now
   for i=1:floor(nnodes/13)
       idx = i*13-13+1:i*13-13+7;
       oldNode = nodes(idx,:);
       newNode(idx*2-1,:) = oldNode;
       idx = idx(1:end-1);
       newNode(idx*2,:) = (oldNode(1:end-1,:)+oldNode(2:end,:))/2;
       
       idx = i*13-13+8:i*13;
       newNode(idx*2-1,:) = nodes(idx,:);
       idx = i*13-13+1:i*13-13+7;
       idxnew = i*26-26+13+[1:2:13];
       newNode(idxnew,:)=(nodes(idx,:)+nodes(idx+13,:))/2;
   end
   % special treatment for the last 7
   i=floor(nnodes/13)+1;
   idx = i*13-13+1:i*13-13+7;
   oldNode = nodes(idx,:);
   newNode(idx*2-1,:) = oldNode;
   idx = idx(1:end-1);
   newNode(idx*2,:) = (oldNode(1:end-1,:)+oldNode(2:end,:))/2;
%    plot(nodes(:,1),nodes(:,2),'rx')
%    hold on
%    plot(newNode(:,1),newNode(:,2),'bo') 
%    hold off
    
% renumber old nodes in elements
newEl(:,2:6) = newEl(:,2:6)*2-1;
% add in new nodes
newEl(:,9+1) = newEl(:,5+1);
newEl(:,5+1) = (newEl(:,1+1)+newEl(:,2+1))/2;
newEl(:,6+1) = (newEl(:,2+1)+newEl(:,3+1))/2;
newEl(:,7+1) = (newEl(:,3+1)+newEl(:,4+1))/2;
newEl(:,8+1) = (newEl(:,4+1)+newEl(:,1+1))/2;

%% rename variables and clearup workspace
nodes = newNode;
els   = newEl;
nnodes = size(nodes,1);
nels   = size(els,1);
nnpe   = size(els,2)-1;

% create BC's 
layers = sqrt(size(newNode,1));%number of nodes per side
% strain on top, fix y on bottom, fix x on left
BC = zeros(layers*2+(layers-1)/2,ndof*2+1);
BC(:,1) = [1:layers:1+layers*(layers-1),layers:layers:(layers-1)*layers,(layers-1)*layers+(layers+1)/2:layers*layers]';
% fix x on left
BC(layers+1:2*layers-1,2) = 1;
BC(end,2) = 1;
% fix y on bottom
BC(1:layers,3) = 1;
% uniform vertical strain on top
re = Q9Re(newNode,nnodes:-1:nnodes-(layers-1)/2, 1, 1);
assert(all(BC(end-(layers-1)/2:end,1)'==nnodes-(layers-1)/2:nnodes));
BC(2*layers:end,5) = BC(2*layers:end,5) + re(:,2);

% clear workspace
clear newEl newNode oldNode re idx idxnew
%% write result to file
writeInput('baseMesh',nodes,els,mats,BC,ndof,d);

