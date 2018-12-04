function elStr = elementStress(X,mat,D)
% elStr = elementStress(X,mat,D)
% need to be a q9 element
% elStr 3x9
% X     2x9
% D     2x9
    elStr = zeros(3,9);
    e = mat(1); % mod of elasticity
    v = mat(2); % poisson ratio
    dp = 3;
    Loc = [-1 -1;
            1 -1;
            1  1;
           -1  1;
            0 -1;
            1  0;
            0  1;
           -1  0;
            0  0];

    E = Elastic(v,e);
    K = zeros(2,9);
    
    for j=1:9
        [B,~] = Bmat(X,Loc(j,:));
        elStr(:,j)= E*B*reshape(D,18,1);
    end
    
end