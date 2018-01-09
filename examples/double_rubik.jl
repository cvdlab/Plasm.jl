#addprocs(Sys.CPU_CORES)
#@everywhere using LARVIEW

using LARVIEW
using PyCall
@pyimport larlib as p


#####

ncubes = 3
V,cells = LARLIB.larCuboids([ncubes,ncubes,ncubes],true)
VV,EV,FV,CV = cells
LARVIEW.viewexploded(V,FV);

t = -ncubes/2
V = LARVIEW.translate([t,t,t],V)
LARVIEW.viewexploded(V,FV);

W = copy(V)
FW = copy(FV)

W = LARVIEW.rotate((0,π/3,0),LARVIEW.rotate((π/3,0,0), W))
LARVIEW.viewexploded(W,FW);


V,W = V',W'
EW = characteristicMatrix(EV)
FE = boundary2(FV,EV)

rubik = [V,EW,FE]
rot_rubik = [W,EW,FE]
two_rubiks = LARLIB.skel_merge(rubik..., rot_rubik...)
arranged_rubiks = LARLIB.spatial_arrangement(two_rubiks...,multiproc=false)

V,cscEV,cscFE,cscCF = arranged_rubiks

ne,nv = size(cscEV)
EV = [findn(cscEV[e,:]) for e=1:ne]
LARVIEW.viewexploded(V',EV)

nf = size(cscFE,1)
FV = [collect(Set(vcat([EV[e] for e in findn(cscFE[f,:])]...)))  for f=1:nf]
LARVIEW.viewexploded(V',FV)

nc = size(cscCF,1)
CV = [collect(Set(vcat([FV[f] for f in findn(cscCF[c,:])]...)))  for c=2:nc]
LARVIEW.viewexploded(V',CV)

######

V,(VV,EV,FV,CV) = LARLIB.larCuboids([2,2,1],true)
V,bases,coboundaries = LARLIB.chaincomplex(V,FV,EV)
EV,FV,CV = bases
cscEV,cscFE,cscCF = coboundaries
LARVIEW.viewexploded(V,EV)
LARVIEW.viewexploded(V,FV)
LARVIEW.viewexploded(V,CV)
(ne,nv),nf,nc = size(cscEV),size(cscFE,1),size(cscCF,1)
nv-ne+nf-nc

#####

V,(VV,EV,FV,CV) = LARLIB.larCuboids([2,2,1],true)
W,FW,EW = copy(V),copy(FV),copy(EV)
collection = [[W,FW,EW]]
for k=1:10
	W,FW,EW = copy(W)+.5,copy(FV),copy(EV)
	append!(collection, [[W,FV,EV]])
end
V,FV,EV = LARLIB.collection2model(collection)
V,bases,coboundaries = LARLIB.chaincomplex(V,FV,EV)
EV,FV,CV = bases
cscEV,cscFE,cscCF = coboundaries
LARVIEW.viewexploded(V,EV)
LARVIEW.viewexploded(V,FV)
LARVIEW.viewexploded(V,CV)

####

TV = LARLIB.triangulate((1:length(FV),ones(length(FV))),V,FV,EV,cscFE,cscCF)
LARVIEW.viewexploded(V,TV)


########

LARVIEW.viewsolidcells(1.5,1.5,3.)(V,CV,FV,EV,cscCF,cscFE)
