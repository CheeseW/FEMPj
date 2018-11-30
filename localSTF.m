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

function [B,J] = Bmat(X,c)
    DN = PartialN(c);    
    J = zeros(2,2);
    J = DN*X';
    
    S = [1 0 0 0; 0 0 0 1; 0 1 1 0];
    G = [inv(J),zeros(2,2);zeros(2,2),inv(J)];
    temp = zeros(4,18);
    for i=1:9
        temp(1:2,2*i-1)=DN(:,i);
        temp(3:4,2*i)=DN(:,i);
    end
    B = S*G*temp;
end

function E = Elastic(v,e)
    E = e/(1-v*v)*[1 v 0; v 1 0; 0 0 (1-v)/2];
end

function DN = PartialN(c)
% DN 2x18
    x = c(1);
    e = c(2);
    DN = zeros(2,9);

    DN(1,1) = ((2*x-1)*(e*e-e))/4;
    DN(1,2) = ((2*x+1)*(e*e-e))/4;
    DN(1,3) = ((2*x+1)*(e*e+e))/4;
    DN(1,4) = ((2*x-1)*(e*e+e))/4;
    DN(1,5) = ((-2*x)*(e*e-e))/2;
    DN(1,6) = ((2*x+1)*(1-e*e))/2;
    DN(1,7) = ((-2*x)*(e*e+e))/2;
    DN(1,8) = ((2*x-1)*(1-e*e))/2;
    DN(1,9) = ((2*x)*(e*e-1));
    
    DN(2,1) = ((x*x-x)*(2*e-1))/4;
    DN(2,2) = ((x*x+x)*(2*e-1))/4;
    DN(2,3) = ((x*x+x)*(2*e+1))/4;
    DN(2,4) = ((x*x-x)*(2*e+1))/4;
    DN(2,5) = ((1-x*x)*(2*e-1))/2;
    DN(2,6) = ((x*x+x)*(-2*e))/2;
    DN(2,7) = ((1-x*x)*(2*e+1))/2;
    DN(2,8) = ((x*x-x)*(-2*e))/2; 
    DN(2,9) = ((x*x-1)*(2*e));
end