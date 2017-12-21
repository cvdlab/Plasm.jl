# addprocs(Sys.CPU_CORES)
# @everywhere using LARVIEW

using LARVIEW

ncubes = 3
V,cells = LARLIB.larCuboids([ncubes,ncubes,ncubes],true)
EV,FV = cells[2:3]
V = convert(Array{Float64,2}, V)
LARVIEW.viewexploded(V,EV);

t = -ncubes/2
V = LARVIEW.translate([t,t,t],V)
#LARVIEW.viewexploded(V,FV);

W = copy(V)
FW = copy(FV)

W = LARVIEW.rotate((0,π/3,0),LARVIEW.rotate((π/3,0,0), W))
#LARVIEW.viewexploded(W,FW);
 
function relation2lar(EV)
	I,J,V = Int64[],Int64[],Int8[]
	for i=1:length(EV)
		for j in EV[i]
			push!(I, i)
			push!(J, j)
			push!(V, 1)
		end
	end
	larEV = sparse(I,J,V)
	return larEV
end

relation2lar(EV)

function boundary1(EV)
	larEV = relation2lar(EV)
	spboundary1 = spzeros(Int8,size(larEV')...)
	for e = 1:length(EV)
		spboundary1[EV[e][1],e] = -1
		spboundary1[EV[e][2],e] = 1
	end
	return spboundary1
end

boundary1(EV)

function uboundary2(FV,EV)
	larFV = relation2lar(FV)
	larEV = relation2lar(EV)
	temp = larFV * larEV'
	sp_u_boundary2 = spzeros(Int8,size(temp)...)
	for j=1:size(temp,2)
		for i=1:size(temp,1)
			if temp[i,j] == 2
				sp_u_boundary2[i,j] = 1
			end
		end
	end
	return sp_u_boundary2
end

uboundary2(FV,EV)

# signed operator ∂_2: C_2 -> C_1
function boundary2(FV,EV)
	sp_u_boundary2 = uboundary2(FV,EV)
	larEV = relation2lar(EV)
	# unsigned incidence relation
	FE = [findn(sp_u_boundary2[f,:]) for f=1:size(sp_u_boundary2,1) ]
	I,J,V = Int64[],Int64[],Int8[]
	vedges = [findn(larEV[:,v]) for v=1:length(cells[1])]
	for f=1:length(FE)
		fedges = Set(FE[f])
		col = 1
		next = pop!(fedges)
		infos = zeros(Int64,(4,length(FE[f])))
		infos[1,col] = 1
		infos[2,col] = next
		infos[3,col] = EV[next][1]
		infos[4,col] = EV[next][2]
		vpivot = infos[4,col]
		while fedges != Set()
			nextedge = intersect(fedges, Set(vedges[vpivot]))
			fedges = setdiff(fedges,nextedge)
			next = pop!(nextedge)
			col += 1
			infos[1,col] = 1
			infos[2,col] = next
			infos[3,col] = EV[next][1]
			infos[4,col] = EV[next][2]
			vpivot = infos[4,col]
			if vpivot == infos[4,col-1]
				infos[3,col],infos[4,col] = infos[4,col],infos[3,col]
				infos[1,col] = -1
				vpivot = infos[4,col]
			end
		end
		for j=1:size(infos,2)
			push!(I, f)
			push!(J, infos[2,j])
			push!(V, infos[1,j])
		end
	end
	spboundary2 = sparse(I,J,V)
	return spboundary2
end

boundary2(FV,EV)


# Characteristic matrix M_2, i.e. M(FV)
function characteristicMatrix(FV)
	I,J,V = Int64[],Int64[],Int8[] 
	for f=1:length(FV)
		for k in FV[f]
			push!(I,f)
			push!(J,k)
			push!(V,1)
		end
	end
	M_2 = sparse(I,J,V)
	return M_2
end

characteristicMatrix(FV)


V,W = V',W'
EW = characteristicMatrix(EV)
FE = boundary2(FV,EV)

rubik = [V,EW,FE]
rot_rubik = [W,EW,FE]
two_rubiks = LARLIB.skel_merge(rubik..., rot_rubik...)
arranged_rubiks = LARLIB.spatial_arrangement(two_rubiks...,multiproc=false)

V_t,cscEV,cscFE,cscCF = arranged_rubiks

ne,nv = size(cscEV)
EV = [findn(cscEV[e,:]) for e=1:ne]
LARVIEW.viewexploded(V_t',EV)

nf = size(cscFE,1)
FV = [collect(Set(vcat([EV[e] for e in findn(cscFE[f,:])]...)))  for f=1:nf]
LARVIEW.viewexploded(V_t',FV)

nc = size(cscCF,1)
CV = [collect(Set(vcat([FV[f] for f in findn(cscCF[c,:])]...)))  for c=2:nc]
LARVIEW.viewexploded(V_t',CV)

