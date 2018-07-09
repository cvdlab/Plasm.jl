module LARVIEW

	using LARLIB
	using PyCall
	@pyimport pyplasm as p

	include("./utilities.jl")
	import Base.view


	# LAR model `(V::vertices,CV::cells)` -> `HPC` model
	function lar2hpc(V::Array{Any,1},CV::Array{Any,1})
		V = hcat(V[1],V...)
		W = [Any[V[h,k] for h=1:size(V,1)] for k=1:size(V,2)]
		hpc = p.STRUCT(p.MKPOLS(PyObject([W,CV,[]])))
	end


	# LAR model `(V::vertices,CV::cells)` -> `HPC` model
	function lar2hpc(V::Array{Float64,2},CV::Array{Array{Int,1},1})
		V = hcat(V[:,1],[V[:,k] for k in 1:size(V,2)]...)
		W = [Any[V[h,k] for h=1:size(V,1)] for k=1:size(V,2)]
		hpc = p.STRUCT(p.MKPOLS(PyObject([W,CV,[]])))
	end

	# Display an  `HPC` (Hierarchica Polyhedral Complex) object with the `PyPlasm` viewer
	view(hpc) = p.VIEW(lar2hpc(V,CV))

	"""
	larView(model)
	
	Show a LAR `model` object, i.e. a pair `(V, CV)`, using the `pyplasm` interactive viewer.
	The *LAR* model (geometry, topology) is transformed into an *HPC* (Hierarchical POlyhedral Complex), introduced by the `PLaSM` language.

	# Example
	```julia
	julia> typeof(model)
	Tuple{Array{Float64, 2}, Array{Array{Int64, 1}, 1}}

	julia> model = hollowBall(1, 2, pi/2, pi/2)([6, 6, 4])
	([0.5 0.625 … 0.875 1.0; -0.5 -0.625 … 0.875 1.0; -0.707107 -0.883883 … 1.23744 1.41421], 
	Array{Int64, 1}[[1, 2, 6, 7, 96, 97, 101, 102], [2, 3, 7, 8, 97, 98, 102, 103], 
	[...]

	julia> larView(model)
	[...]
	```
	"""
	function larView(model::Tuple{Array{Float64, 2}, Array{Array{Int64, 1}, 1}})
		p.VIEW(lar2hpc(model...))
	end
	function larView(model::Tuple{Array{Array{Float64,N} where N,1},Array{Array{Int64,1},1}})
		V,CV = model
		V = hcat(V...)
		p.VIEW(lar2hpc(V,CV))
	end
	function larView(model::Array{Any,1})
		HPC_value_array = [LARVIEW.lar2hpc(item[1],item[2]) for item in model]
		p.VIEW(p.STRUCT(HPC_value_array))
	end
	function larView(V::Array{Float64, 2}, CV::Array{Array{Int64, 1}, 1})
		p.VIEW(lar2hpc(V, CV))
	end
	function larView(V::Array{Int64, 2}, CV::Array{Array{Int64, 1}, 1})
		W = convert(Array{Float64,2}, V)
		p.VIEW(lar2hpc(W, CV))
	end

	# LAR model `(V::vertices,CV::cells)` -> exploded `HPC` object
	function lar2exploded_hpc(V::Array{Any,1},CV::Array{Any,1})
		V = hcat(V[1],V...)
		W = [Any[V[h,k] for h=1:size(V,1)] for k=1:size(V,2)]
		sx,sy,sz = 1.2,1.2,1.2
		hpc = p.EXPLODE(sx,sy,sz)(p.MKPOLS(PyObject([W,CV,[]])))
		
	end

	# LAR model `(V::vertices,CV::cells)` -> exploded `HPC` object
	function lar2exploded_hpc(V::Array{Any,2},CV::Array{Any,2})
		Z = hcat(V[:,1],V)
		W = [Any[Z[h,k] for h=1:size(Z,1)] for k=1:size(Z,2)]
		CV = hcat(CV'...)
		CW = [Any[CV[h,k] for h=1:size(CV,1)] for k=1:size(CV,2)]
		sx,sy,sz = 1.2,1.2,1.2
		hpc = p.EXPLODE(sx,sy,sz)(p.MKPOLS(PyObject([W,CV,[]])))
		hpc = hpc
	end

	# LAR model `(V::vertices,CV::cells)` -> exploded `HPC` object
	function lar2exploded_hpc(V::Array{Int64,2},CV::Array{Array{Int64,1},1})
		Z = hcat(V[:,1],V)
		W = [Any[Z[h,k] for h=1:size(Z,1)] for k=1:size(Z,2)]
		CW = [Any[cell[h] for h=1:length(cell)] for cell in CV]
		sx,sy,sz = 1.2,1.2,1.2
		hpc = p.EXPLODE(sx,sy,sz)(p.MKPOLS(PyObject([W,CV,[]])))
	end

	# LAR model `(V::vertices,CV::cells)` -> exploded `HPC` object
	function lar2exploded_hpc(V::Array{Float64,2},CV::Array{Array{Int64,1},1})
		Z = hcat(V[:,1],V)
		W = [Any[Z[h,k] for h=1:size(Z,1)] for k=1:size(Z,2)]
		CW = [Any[cell[h] for h=1:length(cell)] for cell in CV]
		sx,sy,sz = 1.2,1.2,1.2
		hpc = p.EXPLODE(sx,sy,sz)(p.MKPOLS(PyObject([W,CV,[]])))
	end


	# Display an exploded HPC object with the PyPlasm viewer
	viewexploded(V,CV) = p.VIEW(lar2exploded_hpc(V,CV))




	# LAR `model` ->  numbered `HPC` obyect
	function lar2numbered_hpc(larmodel,scaling=1.0)
		V,cells = larmodel
		VV,EV,FV,CV = cells

		Z = hcat(V[:,1],V)
		W = PyCall.PyObject([Any[Z[h,k] for h=1:size(Z,1)] for k=1:size(Z,2)])

		VV,EV,FV,CV = map(LARVIEW.doublefirst, [VV+1,EV+1,FV+1,CV+1])
		WW,EW,FW,CW = map(LARVIEW.array2list,[VV,EV,FV,CV])
		PyCall.PyObject([WW,EW,FW,CW])
		wire = p.MKPOL(PyCall.PyObject([W,EW,[]]))

		VV,EV,FV,CV = VV-1,EV-1,FV-1,CV-1
		WW,EW,FW,CW = map(LARVIEW.array2list,[VV,EV,FV,CV])
		hpc = p.larModelNumbering(1,1,1)(W,PyCall.PyObject([WW,EW,FW,CW]),wire,scaling)
	end


	# Display a numbered `HPC` object from a `LAR` model with the `PyPlasm` viewer
	viewnumbered(larmodel,scaling=1.0) = p.VIEW(lar2numbered_hpc(larmodel,scaling))



	# translate the columns of `V` matrix by sum with `t` vector
	function translate( t, V )
		broadcast(+,t,V)
	end

	# scale the columns of `V` matrix by product times `s` vector
	function scale( s, V )
		broadcast(*,s,V)
	end

	# rotate the columns of `V` matrix by properly using the `args` parameters
	function rotate(args,V)
		n = length(args)
		if n == 1 # rotation in 2D
			angle = args[1]; Cos = cos(angle); Sin = sin(angle)
			mat = eye(2)
			mat[1,1] = Cos;    mat[1,2] = -Sin;
			mat[2,1] = Sin;    mat[2,2] = Cos;
		elseif n == 3 # rotation in 3D
			mat = eye(3)
			angle = norm(collect(args)); axis = normalize(collect(args))
			Cos = cos(angle); Sin = sin(angle)
			# elementary rotations (in 3D)
			if axis[2]==axis[3]==0.0    # rotation about x
				mat[2,2] = Cos;    mat[2,3] = -Sin;
				mat[3,2] = Sin;    mat[3,3] = Cos;
			elseif axis[1]==axis[3]==0.0    # rotation about y
				mat[1,1] = Cos;    mat[1,3] = Sin;
				mat[3,1] = -Sin;    mat[3,3] = Cos;
			elseif axis[1]==axis[2]==0.0    # rotation about z
				mat[1,1] = Cos;    mat[1,2] = -Sin;
				mat[2,1] = Sin;    mat[2,2] = Cos;
			# general rotations (in 3D)
			else  # general 3D rotation (Rodrigues' rotation formula)    
				I = eye(3) ; u = axis;
				Ux = Array([
					 0        -u[3]      u[2];
					 u[3]        0      -u[1];
					-u[2]      u[1]        0 ])
				UU = Array([
					 u[1]*u[1]    u[1]*u[2]    u[1]*u[3];
					 u[2]*u[1]    u[2]*u[2]    u[2]*u[3];
					 u[3]*u[1]    u[3]*u[2]    u[3]*u[3] ])
				mat = Cos*I + Sin*Ux + (1.0-Cos)*UU
			end
		end
		mat*V
	end

	# Visualize solid cells
	function viewsolidcells(sx=1.2, sy=1.2, sz=1.2)
		scaling = [sx; sy; sz]
		function viewsolidcells0(V,CV,FV,EV,cscCF,cscFE)
			local3cells = LARLIB.map_3cells_to_localbases(V,CV,FV,EV,cscCF,cscFE)
			hpcs = Any[]
			for local3cell in local3cells
				v,tv = local3cell
				centroid = sum(v,2)/size(v,2)
				scaledcentroid = scaling.*centroid
				translation = scaledcentroid - centroid
				w = v .+ translation
				hpc = p.SOLIDIFY(lar2hpc(w,tv))
				append!(hpcs, [hpc])
			end
			p.VIEW(p.STRUCT(hpcs))
			return viewsolidcells0
		end
	end
end
