#addprocs(Sys.CPU_CORES)
#@everywhere using LARVIEW

using LARVIEW
using PyCall
@pyimport larlib as p


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


rubik = [V',EV,FV]
rot_rubik = [W',EW,FW]

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
V,bases,coboundaries,_ = LinearAlgebraicRepresentation.chaincomplex(V,FV,EV)


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
	W,FW,EW = Plasm.rotate([0,0,π/15],copy(W)+.5),copy(FW),copy(EW)
	append!(collection, [[W,FW,EW]])
end
(V,FV,EV),(BF,facespans) = collection2model(collection)
V,bases,coboundaries,_ = LinearAlgebraicRepresentation.chaincomplex(V,FV,EV)
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
