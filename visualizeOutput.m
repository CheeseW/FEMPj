function visualizeOutput(inFile, outFile, shapeN)
% visualizeOutput(inFile, outFile, shapeN)
% need to be in 2d so d==2, also only consider displacements and forces
% no moment and rotation considered

   [nodes, els, mats, ~, ndof, d] = parseInput(inFile); 
   [sol, nnode, nel, nmat] = parseOutput(outFile);
   
   assert(nnode == size(nodes,1));
   assert(nel   == size(els,1));
   assert(nmat  == size(mats,1));
   assert(ndof  == size(sol,2));
   
   VisualiseMesh(nodes+sol(:,1:2), els(:,shapeN+1),1:nel,'b'); 
end 