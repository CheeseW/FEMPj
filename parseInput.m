function [nodes, els, mats, ndof, d] = parseInput(filename)
    fh = fopen(filename,'r');
    tline = fgetl(fh);
    tline = fgetl(fh);
if ischar(tline)  
   meta = sscanf(tline,'%d');
end
    nnode = meta(1);
    ndof  = meta(2);
    nel   = meta(3);
    nnpe  = meta(4);
    d     = meta(5);
    nmats = meta(6);
    nodes = zeros(nnode,d);    
    els   = zeros(nel  ,nnpe+1);    
    for i=1:nnode
        tline = fgetl(fh);
        if ischar(tline)
            data = textscan(tline,'%d %d %f %f %f');
            for v=1:d
                nodes(i,v) = data{v+2};
            end
        end
        tline = fgetl(fh);                
    end
    for i=1:nel
        tline = fgetl(fh);
        if ischar(tline) 
            data = sscanf(tline,'%d');
            for n=1:nnpe+1
                els(i,n) = data(n+1);
            end
        end
    end
    for i=1:nmats
        tline = fgetl(fh);
        if ischar(tline) 
            data = sscanf(tline,'%d %f %f %f'); % assuming only 3 props needed
            for n=1:3
                mats(i,n) = data(n+1);
            end
        end
    end
    fclose(fh);
end