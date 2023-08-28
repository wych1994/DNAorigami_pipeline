function [l_angle,r_angle]=calv2angle(struct)

lt_xy=struct.lt;
lvertex_xy=struct.lvertex;
rvertex_xy=struct.rvertex;
rt_xy=struct.rt;

l_leftarm=p2p(lt_xy(:,1),lt_xy(:,2),lvertex_xy(:,1),lvertex_xy(:,2));
l_rightarm=p2p(rt_xy(:,1),rt_xy(:,2),rvertex_xy(:,1),rvertex_xy(:,2));
l_lt2rvertex=p2p(lt_xy(:,1),lt_xy(:,2),rvertex_xy(:,1),rvertex_xy(:,2));
l_rt2lvertex=p2p(rt_xy(:,1),rt_xy(:,2),lvertex_xy(:,1),lvertex_xy(:,2));
l_barrel=p2p(rvertex_xy(:,1),rvertex_xy(:,2),lvertex_xy(:,1),lvertex_xy(:,2));


l_angle=acosd((l_leftarm.^2+l_barrel.^2-l_lt2rvertex.^2)./(2.*l_leftarm.*l_barrel));
r_angle=acosd((l_rightarm.^2+l_barrel.^2-l_rt2lvertex.^2)./(2.*l_rightarm.*l_barrel));


function l=p2p(x1,y1,x2,y2)
l=sqrt((x1-x2).^2+(y1-y2).^2);
end

end