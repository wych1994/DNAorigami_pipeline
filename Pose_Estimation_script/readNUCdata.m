function A=readNUCdata(str)

A=readmatrix(str);

if isnan(A(1,1))
    A(1,:)=[];
end