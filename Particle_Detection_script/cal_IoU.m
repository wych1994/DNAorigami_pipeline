function IoU=cal_IoU(x,y,x_tar,y_tar)

%Assuming all boxes are 50x50
poly1 = polyshape([x x+50 x+50 x],[y y y+50 y+50]);
poly2 = polyshape([x_tar x_tar+50 x_tar+50 x_tar],[y_tar y_tar y_tar+50 y_tar+50]);
% plot(poly1)
% hold on
% plot(poly2)


I =intersect(poly1,poly2);
U= union(poly1,poly2);

IoU=area(I)/area(U);