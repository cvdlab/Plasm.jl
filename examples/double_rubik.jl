using Lar
Lar = Lar

using Plasm

using PyCall
p = PyCall.pyimport()

#####

ncubes = 3
V,cells = Lar.larCuboids([ncubes,ncubes,ncubes],true)
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
two_rubiks = Lar.skel_merge(rubik..., rot_rubik...)
arranged_rubiks = Lar.spatial_arrangement(two_rubiks...,multiproc=false)

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

V,(VV,EV,FV,CV) = Lar.larCuboids([2,2,1],true)
V,bases,coboundaries = Lar.chaincomplex(V,FV,EV)

# Collect LAR models in a single LAR model
function collection2model(collection)
  facespans = Array{Int64,1}[]
  W,FW,EW,BF = collection[1]
  shiftV = size(W,2)
  shiftF = length(FW)
  append!(facespans, [[1,shiftF]])
  for k=2:length(collection)
	 V,FV,EV,BF = collection[k]
	 W = [W V]
	 FW = [FW; FV + shiftV]
	 EW = [EW; EV + shiftV]
	 BF = [BF; BF + shiftF]
	 shiftV = size(W,2)
	 shiftF = length(FW)
	 append!(facespans, [[facespans[end][2]+1,facespans[end][2]+shiftF]])
  end
  model,boundaries = (W,FW,EW),(BF,facespans)
  return model,boundaries
end

collection = [[V',FV,EV,[]],[W',FW,EW,[]]]
(V,FV,EV),_ = collection2model(collection)
V,bases,coboundaries,_ = Lar.chaincomplex(V,FV,EV)


######

V,(VV,EV,FV,CV) = Lar.larCuboids([2,2,1],true)
V,bases,coboundaries = Lar.chaincomplex(V,FV,EV)

EV,FV,CV = bases
cscEV,cscFE,cscCF = coboundaries
Plasm.viewexploded(V,EV)
Plasm.viewexploded(V,FV)
Plasm.viewexploded(V,CV)
(ne,nv),nf,nc = size(cscEV),size(cscFE,1),size(cscCF,1)
nv-ne+nf-nc

#####

V,(VV,EV,FV,CV) = Lar.larCuboids([2,2,1],true)

W,FW,EW = copy(V),copy(FV),copy(EV)
collection = [[W,FW,EW]]
for k=1:10
	W,FW,EW = Plasm.rotate([0,0,π/15],copy(W)+.5),copy(FW),copy(EW)
	append!(collection, [[W,FW,EW]])
end
V,FV,EV = Lar.collection2model(collection)
V,bases,coboundaries = Lar.chaincomplex(V,FV,EV)

EV,FV,CV = bases
cscEV,cscFE,cscCF = coboundaries
Plasm.viewexploded(V,EV)
Plasm.viewexploded(V,FV)
Plasm.viewexploded(V,CV)

