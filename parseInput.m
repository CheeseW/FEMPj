function [nodes, els, mats, BC, ndof, d] = parseInput(filename)
% BC - each row: [node#, ndof x condType, ndof x value]
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
    nmat = meta(6);
    nodes = zeros(nnode,d);    
    els   = zeros(nel  ,nnpe+1);    
    BC    = [];
    for i=1:nnode
        tline = fgetl(fh);
        cond = zeros(1,ndof*2+1);
        if ischar(tline)
            data = textscan(tline,'%d %d %f %f %f');
            cond(1) = i;
            rem = data{2}/10^(6-ndof);
            for v=ndof:-1:1
                cond(v+1) = mod(rem,10);
                rem = floor(rem/10);
            end
            for v=1:d
                nodes(i,v) = data{v+2};
            end
        end
        tline = fgetl(fh);                
        if ischar(tline)
            data = textscan(tline,'%f'); 
            if sum(cell2mat(data))~=0||sum(cond(2:ndof+1))~=0
                cond(ndof+2:end) = data{1:ndof};
                BC = [BC;cond];
            end
        end
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
    for i=1:nmat
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