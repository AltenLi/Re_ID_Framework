% The make utility for all the C and MEX code

function make(command)

if (nargin > 0 && strcmp(command,'clean'))
    delete('*.mexglx');
    delete('*.mexw32');
    delete('lsmlib/*.mexglx');
    delete('lsmlib/*.mexw32');
    return;
end
mex CC=g++ csparse.c -largeArrayDims 
mex CC=g++ ic.c -largeArrayDims 
mex CC=g++ imnb.c -largeArrayDims 
mex CC=g++ parmatV.c -largeArrayDims 
mex CC=g++ spmd1.c -largeArrayDims 
