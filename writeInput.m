function writeInput(filename,nodes,els,mats,BC,ndof,d)
% right now only consider the case of 9 node quad
% TODO: have a more general version

% get metadata
nnodes = size(nodes,1);
nels   = size(els,1);
nnpe   = size(els,2)-1;
nmats  = size(mats,1);

[~,reorder] = sort(BC(:,1));
BC = BC(reorder,:);

% write result to correct format
bcidx = 1;
fh = fopen(filename,'wt');
fprintf(fh,'ANALYSIS OF PLATE WITH HOLE -- DATA FOR %d Q9 ELEMENTS', size(els,1));
fprintf(fh,'\n');
fprintf(fh,'%5d%5d%5d%5d%5d%5d',nnodes,ndof,nels,nnpe,d,nmats);
fprintf(fh,'\n');
for i=1:nnodes
    if i==BC(bcidx,1)
        fprintf(fh,'%5d    %1d%1d0000',i,BC(bcidx,2),BC(bcidx,3));
        fprintf(fh,'%10.3f%10.3f%10.3f%10.3f',nodes(i,1),nodes(i,2),0);
        fprintf(fh,'\n');
        fprintf(fh,'               %10g%10g',BC(bcidx,ndof+1+1),BC(bcidx,ndof+2+1));
        bcidx = bcidx+1;
    else
        fprintf(fh,'%5d    000000%10.3f%10.3f%10.3f%10.3f',i,nodes(i,1),nodes(i,2),0);
        fprintf(fh,'\n');
        fprintf(fh,'               %10g%10g',0,0);
    end
    fprintf(fh,'\n');    
end
for i=1:nels
    fprintf(fh,'%5d%5d',i,els(i,1));
    for j=1:nnpe
        fprintf(fh,'%5d',els(i,j+1));
    end
    fprintf(fh,'\n');
end
for i=1:size(mats,1)
    fprintf(fh,'%5d%10g%10g%10g',i,mats(i,1),mats(i,2),mats(i,3));
    fprintf(fh,'\n');    
end
fclose(fh);
end