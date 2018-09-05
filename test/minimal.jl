using LinearAlgebraicRepresentation
using Plasm

V,(VV,EV,FV,CV) = LinearAlgebraicRepresentation.cuboid([1,1,1],true);

hpc = Plasm.mkpol(V,EV)
Plasm.view(hpc)
