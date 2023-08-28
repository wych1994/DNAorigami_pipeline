function cmatrix=parsecbox(data)

[num_data,~]=size(data);
x=zeros(num_data,1);
y=x;
conf=x;
for i=1:num_data
    x(i)=data{i,1};
    y(i)=data{i,2};
    conf(i)=data{i,9};
end

cmatrix=[x y conf];