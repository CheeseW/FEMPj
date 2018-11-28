function [nodes, els, ndof, d] = parseInput(filename)
    filename = 'q9single';
    fh = fopen(filename,'r');
    tline = fgetl(fh);
while ischar(tline)
    disp(tline)
    tline = fgetl(fh);
end
    fclose(fh);
end