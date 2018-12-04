function E = Elastic(v,e)
    E = e/(1-v*v)*   [1 v 0; 
                      v 1 0; 
                      0 0 (1-v)/2];
end