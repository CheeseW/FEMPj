function [sol, nnode, nel, nmat] = parseOutput(filename)
    % [dofv, nnode, nel, nmat] = parseOutput(filename)
    % this function will not parse input data (nodes, el, mat, BC, etc)
    % it will only parse the computed nodal displacement

    nodeHeader = ' NODAL DATA  (#,X,Y,Z,K1 THRU K6,F1,F2,...)';
    eleHeader  = ' ELEMENT DATA  (#,MAT#,NODE1,NODE2,...)';
    matHeader  = ' MATERIAL DATA  (#,RMAT1,RMAT2,...)';
    solHeader  = ' NODAL POINT SOLUTION  (NODE #, NODAL DOF #, VALUE OF THE DOF)';
    
    fh = fopen(filename,'r');
    % get rid of initial meta data
    for i=1:40
        fgetl(fh);
    end
    % count nodes
    tline = fgetl(fh);
    if ischar(tline)&&~strcmp(tline,nodeHeader)
        disp(['Something wrong with node header',' : ',nodeHeader]);
        disp(tline);
        return
    end
    fgetl(fh);
    tline = fgetl(fh);
    nnode = 0;
    while ischar(tline)&&length(tline)>0
        nnode = nnode+1;
        tline = fgetl(fh);
    end
    
    for i=1:2
        fgetl(fh);
    end
    tline = fgetl(fh);
    %count elements
    if ischar(tline)&&~strcmp(tline,eleHeader)
        disp(['Something wrong with element header',' : ',eleHeader]);
        disp(tline);
        return
    end
    fgetl(fh);
    tline = fgetl(fh);
    nel = 0;
    while ischar(tline)&&length(tline)>0
        nel = nel+1;
        tline = fgetl(fh);
%         disp(tline)
    end
    
    for i=1:2
        fgetl(fh);
    end
    tline = fgetl(fh);
    %count materials
    if ischar(tline)&&~strcmp(tline,matHeader)
        disp(['Something wrong with material header',' : ',matHeader]);
        disp(tline);
        return
    end
    fgetl(fh);
    tline = fgetl(fh);
    nmat = 0;
    while ischar(tline)&&length(tline)>0
        nmat = nmat+1;
        tline = fgetl(fh);
    end
    
    % parse dof values
    for i=1:9
        fgetl(fh);
    end
    tline = fgetl(fh);
    %count elements
    if ischar(tline)&&~strcmp(tline,solHeader)
        disp(['Something wrong with element header',' : ',solHeader]);
        disp(tline);
        return
    end
    fgetl(fh);
    tline = fgetl(fh);
    firstdof = true;
    firstnode = true;
    nodeval = [];
    node = 0;
    while ischar(tline)&&length(tline)>0
        data = strsplit(strip(tline));
%         data = cell2mat(data);
        if firstdof
            node = str2num(data{1}); % TODO: assert(node == 1)
            firstdof = false;
        end
        for i=1:floor(length(data)/3) % [node# dof# v] per dof
            nn = str2num(data{i*3-3+1});
            dn = str2num(data{i*3-3+2});
            va = str2num(data{i*3-3+3});
           if (nn == node) 
               if (dn>length(nodeval))
                    nodeval = [nodeval,zeros(1,dn-length(nodeval)-1),va];
               else
                    nodeval(dn) = va;
               end
           else
               if firstnode
                   firstnode = false;
                   sol = zeros(nnode,length(nodeval));
                   sol(1,:) = nodeval;
               end
               sol(nn,dn) = va;
           end
        end
        tline = fgetl(fh);
    end
    
    fclose(fh);
end  