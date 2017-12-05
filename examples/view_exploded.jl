using LARVIEW

geom_0 = hcat([[x] for x=0.:10]...)
topol_0 = [[i,i+1] for i=1:9]
geom_1 = hcat([[0.],[1.],[2.]]...)
topol_1 = [[1,2],[2,3]]

model_0 = (geom_0,topol_0)
model_1 = (geom_1,topol_1)
model_2 = LARLIB.larModelProduct(model_0, model_1)
model_3 = LARLIB.larModelProduct(model_2, model_1)


LARVIEW.view(model_3...)
LARVIEW.viewexploded(model_3...)
LARVIEW.viewexploded(model_3[1],model_3[2])

shape = (10,10,2)
cubes = LARLIB.larCuboids(shape,true)
V,FV = cubes[1],cubes[2][3]
LARVIEW.viewexploded(V,FV)

V1,EV = LARLIB.larCuboids([30])
W = hcat( map(u->[cos(u*(2π/30));sin(u*(2π/30))], V1 )...)
LARVIEW.viewexploded(V1,EV)
LARVIEW.viewexploded(W,EV)

V2,FV = LARLIB.larCuboids([30,6])
V2 = [2π/30 0; 0 1/6] * V2
W = [V2[:,k] for k=1:size(V2,2)]
Z = hcat( map(p->let (u,v) = p; [v*cos(u); v*sin(u)] end, W) ...)
LARVIEW.viewexploded(V2,FV)
LARVIEW.viewexploded(Z,FV)

V3,CV = LARLIB.larCuboids([16,32,1])
V3 = [π/16 0 0; 0 2π/32 0; 0 0 1] * V3 
W = [V3[:,k]-[π/2,π,1/2] for k=1:size(V3,2)] 
Z = hcat( map(p->let (u,v,w) = p; [w*cos(u)*cos(v); w*cos(u)*sin(v); w*sin(u)] end, W) ...)
LARVIEW.viewexploded(V3,CV)
LARVIEW.viewexploded(Z,CV)

