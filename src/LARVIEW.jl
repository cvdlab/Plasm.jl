module LARVIEW

    using LARLIB
    using PyCall
    
    include("./utilities.jl")
    
    @pyimport larlib as p

	function view(V::Array{Any,1},CV::Array{Any,1})
		V = hcat(V[1],V...)
		W = [Any[V[h,k] for h=1:size(V,1)] for k=1:size(V,2)]
		p.VIEW(p.STRUCT(p.MKPOLS(PyObject([W,CV,[]]))))
	end

	function view(V::Array{Float64,2},CV::Array{Array{Int,1},1})
		V = hcat(V[:,1],[V[:,k] for k in 1:size(V,2)]...)
		W = [Any[V[h,k] for h=1:size(V,1)] for k=1:size(V,2)]
		p.VIEW(p.STRUCT(p.MKPOLS(PyObject([W,CV,[]]))))
	end

	function viewexploded(V::Array{Any,1},CV::Array{Any,1})
		V = hcat(V[1],V...)
		W = [Any[V[h,k] for h=1:size(V,1)] for k=1:size(V,2)]
		p.VIEW(p.EXPLODE(1.2,1.2,1.2)(p.MKPOLS(PyObject([W,CV,[]]))))
	end

	function viewexploded(V::Array{Any,2},CV::Array{Any,2})
		Z = hcat(V[:,1],V)
		W = [Any[Z[h,k] for h=1:size(Z,1)] for k=1:size(Z,2)]
		CV = hcat(CV'...)
		CW = [Any[CV[h,k] for h=1:size(CV,1)] for k=1:size(CV,2)]
		p.VIEW(p.EXPLODE(1.2,1.2,1.2)(p.MKPOLS(PyObject([W,CW,[]]))))
	end

	function viewexploded(V::Array{Int64,2},CV::Array{Array{Int64,1},1})
		Z = hcat(V[:,1],V)
		W = [Any[Z[h,k] for h=1:size(Z,1)] for k=1:size(Z,2)]
		CW = [Any[cell[h] for h=1:length(cell)] for cell in CV]
		p.VIEW(p.EXPLODE(1.2,1.2,1.2)(p.MKPOLS(PyObject([W,CW,[]]))))
	end

	function viewexploded(V::Array{Float64,2},CV::Array{Array{Int64,1},1})
		Z = hcat(V[:,1],V)
		W = [Any[Z[h,k] for h=1:size(Z,1)] for k=1:size(Z,2)]
		CW = [Any[cell[h] for h=1:length(cell)] for cell in CV]
		p.VIEW(p.EXPLODE(1.2,1.2,1.2)(p.MKPOLS(PyObject([W,CW,[]]))))
	end

    
end
