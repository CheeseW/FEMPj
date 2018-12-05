function visualizeInput(filename, shapeN, bndr)
% visualizeInput(filename, shapeN, bndr)
% need to be in 2d so d==2, also only consider displacements and forces
% no moment and rotation considered
% bndr       : 'd' - displacement
%              'f' - force
%              's' - supoorts
%              any combinition of the above
   [nodes, els, mats, BC, ndof, d] = parseInput(filename); 
   nnodes = size(nodes,1);
   nels   = size(els,1);
   nnpe   = size(els,2)-1;
   nmats  = size(mats,1);
   VisualiseMesh(nodes, els(:,shapeN+1),1:nels,'b'); 

   if ~isempty(BC)
   nd = BC(:,1);
   hold on
   % asumming the first 2 dof's represent displacement
   if any(strfind(bndr,'d'))
        % plot the dispfield
        mask = any(BC(:,2:3)==2,2);
        idx = nd(mask);
        quiver(nodes(idx,1),nodes(idx,2),BC(mask,ndof+2),BC(mask,ndof+3),0,'Linewidth',2);
   end
   if any(strfind(bndr,'f'))
        % plot the forces
        maskf = any(BC(:,2:3)==0,2);
        idxf   = nd(maskf);
        fx = BC(maskf,ndof+2);
        fy = BC(maskf,ndof+3);
        fx(BC(maskf,2)~=0) = 0;
        fy(BC(maskf,3)~=0) = 0;

        quiver(nodes(idxf,1),nodes(idxf,2),fx,fy,.5,'r','Linewidth',2);
        % add force value to force vectors
        for i=1:length(idxf)
            if (fx(i)~=0 || fy(i)~=0)
                text(nodes(idxf(i),1)+0.1,nodes(idxf(i),2)+0.1,['(',num2str(fx(i)),',',num2str(fy(i)),')'],'color','red');        
            end
        end
   end
   if any(strfind(bndr,'s'))
        % plot the supports
        idxrx = nd(BC(:,2)==1&BC(:,3)~=1);            % roller support in x
        idxry = nd(BC(:,3)==1&BC(:,2)~=1);            % roller support in y
        idxpn = nd(all(BC(:,2:3)==1,2));   % pin support

        % add support conditions
        plot(nodes(idxrx,1),nodes(idxrx,2),'o','MarkerFaceColor','g','MarkerSize',10);
        plot(nodes(idxry,1),nodes(idxry,2),'o','MarkerFaceColor','y','MarkerSize',10);
        plot(nodes(idxpn,1),nodes(idxpn,2),'^','MarkerFaceColor','g','MarkerSize',10);
   end
   hold off
   end
end