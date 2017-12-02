module LARVIEW

	using LARLIB
	using PyCall

	@pyimport larlib as p

	include("./utilities.jl")


	"""
	LAR model (V,CV) -> PyPlasm Viewer
	Display using the HPC object translating (V,CV).

	HPC = (Hierarchica Polyhedral Complex) is the python Class of Pyplasm
	geometric values.
	"""
	function view(V::Array{Any,1},CV::Array{Any,1})
		V = hcat(V[1],V...)
		W = [Any[V[h,k] for h=1:size(V,1)] for k=1:size(V,2)]
		p.VIEW(p.STRUCT(p.MKPOLS(PyObject([W,CV,[]]))))
	end


	"""
	LAR model (V::vertices,CV::cells) -> PyPlasm Viewer
	
	Display using the HPC object translating (V,CV).

	HPC = (Hierarchica Polyhedral Complex) is the python Class of Pyplasm
	geometric values.
	"""
	function view(V::Array{Float64,2},CV::Array{Array{Int,1},1})
		V = hcat(V[:,1],[V[:,k] for k in 1:size(V,2)]...)
		W = [Any[V[h,k] for h=1:size(V,1)] for k=1:size(V,2)]
		p.VIEW(p.STRUCT(p.MKPOLS(PyObject([W,CV,[]]))))
	end


	"""
	LAR model (V::vertices,CV::cells) -> PyPlasm Viewer
	
	Display exploded sequence of HPCs corresponding to cells.
	
	HPC = (Hierarchica Polyhedral Complex) is the python Class of Pyplasm
	geometric values.
	"""
	function viewexploded(V::Array{Any,1},CV::Array{Any,1})
		V = hcat(V[1],V...)
		W = [Any[V[h,k] for h=1:size(V,1)] for k=1:size(V,2)]
		sx,sy,sz = 1.2,1.2,1.2
		hpc = p.EXPLODE(sx,sy,sz)(p.MKPOLS(PyObject([W,CV,[]])))
		p.VIEW(hpc)
	end

	"""
	LAR model (V::vertices,CV::cells) -> PyPlasm Viewer
	
	Display exploded sequence of HPCs corresponding to cells.
	
	HPC = (Hierarchica Polyhedral Complex) is the python Class of Pyplasm
	geometric values.
	"""
	function viewexploded(V::Array{Any,2},CV::Array{Any,2})
		Z = hcat(V[:,1],V)
		W = [Any[Z[h,k] for h=1:size(Z,1)] for k=1:size(Z,2)]
		CV = hcat(CV'...)
		CW = [Any[CV[h,k] for h=1:size(CV,1)] for k=1:size(CV,2)]
		sx,sy,sz = 1.2,1.2,1.2
		hpc = p.EXPLODE(sx,sy,sz)(p.MKPOLS(PyObject([W,CV,[]])))
		p.VIEW(hpc)
	end

	"""
	LAR model (V::vertices,CV::cells) -> PyPlasm Viewer
	
	Display exploded sequence of HPCs corresponding to cells.
	
	HPC = (Hierarchica Polyhedral Complex) is the python Class of Pyplasm
	geometric values.
	"""
	function viewexploded(V::Array{Int64,2},CV::Array{Array{Int64,1},1})
		Z = hcat(V[:,1],V)
		W = [Any[Z[h,k] for h=1:size(Z,1)] for k=1:size(Z,2)]
		CW = [Any[cell[h] for h=1:length(cell)] for cell in CV]
		sx,sy,sz = 1.2,1.2,1.2
		hpc = p.EXPLODE(sx,sy,sz)(p.MKPOLS(PyObject([W,CV,[]])))
		p.VIEW(hpc)
	end

	"""
	LAR model (V::vertices,CV::cells) -> PyPlasm Viewer
	
	Display exploded sequence of HPC objects corresponding to cells.
	
	HPC = (Hierarchica Polyhedral Complex) is the python Class of Pyplasm
	geometric values.
	"""
	function viewexploded(V::Array{Float64,2},CV::Array{Array{Int64,1},1})
		Z = hcat(V[:,1],V)
		W = [Any[Z[h,k] for h=1:size(Z,1)] for k=1:size(Z,2)]
		CW = [Any[cell[h] for h=1:length(cell)] for cell in CV]
		sx,sy,sz = 1.2,1.2,1.2
		hpc = p.EXPLODE(sx,sy,sz)(p.MKPOLS(PyObject([W,CV,[]])))
		p.VIEW(hpc)
	end

	"""
	`larmodel, scaling=1.0`` -> PyPlasm Viewer, where all dimensions of 3D model are shown.
	
	Display numbered sequence of `HPC`` objects corresponding to cells with different colors.
	
	`HPC`` = (Hierarchica Polyhedral Complex) is the python Class of `Pyplasm``
	geometric values.
	"""
	function viewnumbered(larmodel,scaling=1.0)
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
		p.VIEW(hpc)
	end

end
