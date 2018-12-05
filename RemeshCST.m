clear
clc

filename = 'cstdata';
   [nodes, els, mats, BC, ndof, d] = parseInput(filename); 
   nnodes = size(nodes,1);
   nels   = size(els,1);
   nnpe   = size(els,2)-1;
   nmats  = size(mats,1);

   %rework connectivity to make q4 with center nodes first
   newEl = zeros(nels/4,5);
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
   VisualiseMesh(nodes, newEl(:,2:5),1:nels/4,'b'); 

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
   plot(nodes(:,1),nodes(:,2),'rx')
   hold on
   plot(newNode(:,1),newNode(:,2),'bo') 
   hold off
