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