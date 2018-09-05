using LinearAlgebraicRepresentation
L = LinearAlgebraicRepresentation
using Plasm

V,(VV,EV,FV,CV) = L.cuboid([1,1,1],true);

hpc = Plasm.mkpol(V,EV)
Plasm.view(hpc)

Plasm.view(V,CV)

