function VisualiseMesh(nodes,els,C,numbering)
% visualize the 2d mesh
% nodes, ele : structure for nodes and mesh
% C          : color for each element
% numbering  : 'n' - number nodes only
%              'e' - number elements only
%              'b' - number both
%              no numbering otherwise

% collect mesh info
    nnode = size(nodes,1);
    nel   = size(els,1);
    nnpe  = size(els,2);

    X = zeros(nnpe,nel);
    Y = zeros(nnpe,nel);
    for i=1:nel
        X(:,i) = nodes(els(i,:),1);
        Y(:,i) = nodes(els(i,:),2);
    end
        patch(X,Y,C);
    if (numbering=='n'||numbering == 'b')
        for i=1:nnode
            text(nodes(i,1)-.1,nodes(i,2)-.1,num2str(i),'FontWeight','bold');
        end
    end
    
    if (numbering=='e'||numbering == 'b')
        xe = sum(X,1)/nnpe;
        ye = sum(Y,1)/nnpe;
        for i=1:nel
            text(xe(i),ye(i),num2str(i),'color','white');        
        end
    end

end 