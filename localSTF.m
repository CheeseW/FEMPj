function K = localSTF(X,mat)
% need to be a q9 element
% K 18x18
% X 2x9
    t = mat(3); % thickness
    e = mat(1); % mod of elasticity
    v = mat(2); % poisson ratio
    dp = 3;
    GQ = [0 -0.7745966692414834,0.7745966692414834];
    GW = [ 0.8888888888888888 0.5555555555555556 0.5555555555555556 ];
    E = Elastic(v,e);
    K = zeros(18,18,9);
    
    for i=1:dp
        for j=1:dp
            [B,J] = Bmat(X,[GQ(i), GQ(j)]);
                K(:,:,i*dp-dp+j) = B'*E*B*t*det(J)*GW(i)*GW(j);
        end
    end
end