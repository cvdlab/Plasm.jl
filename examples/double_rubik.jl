#addprocs(Sys.CPU_CORES)
#@everywhere using Plasm

using Plasm
using PyCall
@pyimport pyplasm as p


#####

ncubes = 3
V,cells = LinearAlgebraicRepresentation.larCuboids([ncubes,ncubes,ncubes],true)
VV,EV,FV,CV = cells
Plasm.viewexploded(V,FV);

t = -ncubes/2
V = Plasm.translate([t,t,t],V)
Plasm.viewexploded(V,FV);

W = copy(V)
FW = copy(FV)

W = Plasm.rotate((0,π/3,0),Plasm.rotate((π/3,0,0), W))
Plasm.viewexploded(W,FW);


V,W = V',W'
EW = characteristicMatrix(EV)
FE = boundary2(FV,EV)

rubik = [V,EW,FE]
rot_rubik = [W,EW,FE]
two_rubiks = LinearAlgebraicRepresentation.skel_merge(rubik..., rot_rubik...)
arranged_rubiks = LinearAlgebraicRepresentation.spatial_arrangement(two_rubiks...,multiproc=false)

V,cscEV,cscFE,cscCF = arranged_rubiks

ne,nv = size(cscEV)
EV = [findn(cscEV[e,:]) for e=1:ne]
Plasm.viewexploded(V',EV)

nf = size(cscFE,1)
FV = [collect(Set(vcat([EV[e] for e in findn(cscFE[f,:])]...)))  for f=1:nf]
Plasm.viewexploded(V',FV)

nc = size(cscCF,1)
CV = [collect(Set(vcat([FV[f] for f in findn(cscCF[c,:])]...)))  for c=2:nc]
Plasm.viewexploded(V',CV)

######

V,(VV,EV,FV,CV) = LinearAlgebraicRepresentation.larCuboids([2,2,1],true)
V,bases,coboundaries = LinearAlgebraicRepresentation.chaincomplex(V,FV,EV)
EV,FV,CV = bases
cscEV,cscFE,cscCF = coboundaries
Plasm.viewexploded(V,EV)
Plasm.viewexploded(V,FV)
Plasm.viewexploded(V,CV)
(ne,nv),nf,nc = size(cscEV),size(cscFE,1),size(cscCF,1)
nv-ne+nf-nc

#####

V,(VV,EV,FV,CV) = LinearAlgebraicRepresentation.larCuboids([2,2,1],true)
W,FW,EW = copy(V),copy(FV),copy(EV)
collection = [[W,FW,EW]]
for k=1:10
	W,FW,EW = rotate([0,0,π/15],copy(W)+.5),copy(FV),copy(EV)
	append!(collection, [[W,FV,EV]])
end
V,FV,EV = LinearAlgebraicRepresentation.collection2model(collection)
V,bases,coboundaries = LinearAlgebraicRepresentation.chaincomplex(V,FV,EV)
EV,FV,CV = bases
cscEV,cscFE,cscCF = coboundaries
Plasm.viewexploded(V,EV)
Plasm.viewexploded(V,FV)
Plasm.viewexploded(V,CV)

####

TV = LinearAlgebraicRepresentation.triangulate((1:length(FV),ones(length(FV))),V,FV,EV,cscFE,cscCF)
Plasm.viewexploded(V,TV)


########

Plasm.viewsolidcells(1.5,1.5,3.)(V,CV,FV,EV,cscCF,cscFE)
