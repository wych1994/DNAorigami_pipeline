function angle=calangle(struct)

tipl_xy=struct.tipl;
vertex_xy=struct.vertex;
tipr_xy=struct.tipr;

l1=sqrt((tipl_xy(:,1)-vertex_xy(:,1)).^2+(tipl_xy(:,2)-vertex_xy(:,2)).^2);
l2=sqrt((tipr_xy(:,1)-vertex_xy(:,1)).^2+(tipr_xy(:,2)-vertex_xy(:,2)).^2);
l_strut=sqrt((tipr_xy(:,1)-tipl_xy(:,1)).^2+(tipr_xy(:,2)-tipl_xy(:,2)).^2);
angle=acosd((l1.^2+l2.^2-l_strut.^2)./(2.*l1.*l2));