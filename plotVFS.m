% Plot Value Function Script

[p,a]=meshgrid(param.posBounds(1):.05:param.posBounds(2), actions(1):.5:actions(3));
vt=0;
VF=zeros(size(p));

for it=1:size(p,1)
    for jt =1:size(p,2)
        VF(it,jt) =  getValue(type, theta, state,ApproxMap ,param, d);
    end
end