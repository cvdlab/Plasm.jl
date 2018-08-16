using PyCall
@pyimport pyplasm as p

using LARLIB
L = LARLIB

using LARVIEW
View = LARVIEW.view

import Base.cat
	

""" 
	apply(affineMatrix::Matrix)(larmodel::LAR)::LAR

Apply the `affineMatrix` parameter to the vertices of `larmodel`.
"""
function apply(affineMatrix)
	function apply0(larmodel)
		return L.struct2lar(L.Struct([ affineMatrix,larmodel ]))
	end
	return apply0
end

# Example

```
julia> square = LARLIB.cuboid([1,1])
([0.0 0.0 1.0 1.0; 0.0 1.0 0.0 1.0], Array{Int64,1}[[1, 2, 3, 4]])

julia> LARVIEW.apply(LARLIB.t(1,2))(square)
([1.0 1.0 2.0 2.0; 2.0 3.0 2.0 3.0], Array{Int64,1}[[1, 2, 3, 4]])
```
""" 
	comp(funs::Array)

Standard mathematical composition. 

Pipe execution from right to left on application to actual parameter.
"""
function comp(funs)
    function compose(f,g)
	  return x -> f(g(x))
	end
    id = x->x
    return reduce(compose,id,funs)
end



"""
	cons(funs::Array)(x::Any)::Array

*Construction* functional of FL and PLaSM languages.

Provides a *vector* functional that returns the array of 
applications of component functions to actual parameter.

# Example 

```
julia> LARVIEW.cons([cos,sin])(0)
2-element Array{Float64,1}:
 1.0
 0.0
```
"""
function cons(funs)
	return x -> [f(x) for f in funs]
end



""" 
	k(Any)(x)

*Constant* functional of FL and PLaSM languages.

Gives a constant functional that always returns the actual parameter
when applied to another parameter.

#	Examples

```
julia> LARVIEW.k(10)(100)
10

julia> LARVIEW.k(sin)(cos)
sin
```
"""
function k(Any)
	x->Any
end


""" 
	aa(fun::Function)(args::Array)::Array

AA applies fun to each element of the args sequence 

# Example 

```
julia> LARVIEW.aa(sqrt)([1,4,9,16])
4-element Array{Float64,1}:
 1.0
 2.0
 3.0
 4.0
```
"""
function aa(fun)
	function aa1(args::Array)
		map(fun,args)
	end
	return aa1
end



""" 
	id(x::Anytype)

Identity function.  Return the argument.

"""
id = x->x



	
""" 
	distr(args::Union{Tuple,Array})(x::Any)::Array

Distribute right. Returns the `pair` array with the elements of `args` and `x`

# Example 

```
julia> LARVIEW.distr(([1,2,3],10))
3-element Array{Array{Int64,1},1}:
 [1, 10]
 [2, 10]
 [3, 10]

julia> LARVIEW.distr([[1,2,3],10])
3-element Array{Array{Int64,1},1}:
 [1, 10]
 [2, 10]
 [3, 10]
```
"""
function distr(args)
	list,element = args
	return [ [e,element] for e in list ]
end




#
ascii32 = ([0.0; 0.0],Array{Int64,1}[[1]])
ascii33 = ([1.75 1.75 2.0 2.0 1.5 1.5; 1.75 5.5 0.5 1.0 1.0 0.5],Array{Int64,1}[[1,2],[3,4],[4,5],[5,6],[6,3]])
ascii34 = ([1.0 2.0 2.0 2.0 1.5 1.5 2.0 3.0 3.0 3.0 2.5 2.5; 4.0 5.0 5.5 6.0 6.0 5.5 4.0 5.0 5.5 6.0 6.0 5.5],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[6,3],[7,8],[8,9],[9,10],[10,11],[11,12],[12,9]])
ascii35 = ([1.0 3.0 1.0 3.0 1.25 1.75 2.25 2.75; 2.5 2.5 3.5 3.5 1.75 4.0 1.75 4.0],Array{Int64,1}[[1,2],[3,4],[5,6],[7,8]])
ascii36 = ([0.0 1.0 3.0 4.0 4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0 2.0 2.0; 1.0 0.0 0.0 1.0 2.0 3.0 3.0 4.0 5.0 6.0 6.0 5.0 -0.5 6.5],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[6,7],[7,8],[8,9],[9,10],[10,11],[11,12],[13,14]])
ascii37 = ([2.5 2.5 2.0 2.0 2.5 2.5 2.0 2.0 1.5 3.5; 0.0 0.5 0.5 0.0 5.5 6.0 6.0 5.5 5.5 11.5],Array{Int64,1}[[1,2],[2,3],[3,4],[4,1],[5,6],[6,7],[7,8],[8,5],[9,10]])
ascii38 = ([4.0 3.0 1.0 0.0 0.0 1.0 2.0 3.0 3.0 2.0 1.0 1.0 3.0 4.0; 1.0 0.0 0.0 1.0 2.0 3.0 3.0 4.0 5.0 6.0 5.0 4.0 2.0 2.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[6,7],[7,8],[8,9],[9,10],[10,11],[11,12],[12,13],[13,14]])
ascii39 = ([1.0 2.0 2.0 2.0 1.5 1.5; 4.0 5.0 5.5 6.0 6.0 5.5],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[6,3]])
ascii40 = ([2.0 1.0 0.5 1.0 2.0; 0.0 1.0 3.0 5.0 6.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5]])
ascii41 = ([2.0 3.0 3.5 3.0 2.0; 0.0 1.0 3.0 5.0 6.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5]])
ascii42 = ([1.0 3.0 2.0 2.0 1.0 3.0 1.0 3.0; 3.0 3.0 2.0 4.0 2.0 4.0 4.0 2.0],Array{Int64,1}[[1,2],[3,4],[5,6],[7,8]])
ascii43 = ([1.0 3.0 2.0 2.0; 3.0 3.0 2.0 4.0],Array{Int64,1}[[1,2],[3,4]])
ascii44 = ([1.0 2.0 2.0 2.0 1.5 1.5; -1.0 0.0 0.5 1.0 1.0 0.5],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[6,3]])
ascii45 = ([1.0 3.0; 3.0 3.0],Array{Int64,1}[[1,2]])
ascii46 = ([2.0 2.0 1.5 1.5 2.0; 0.0 0.5 0.5 0.0 0.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5]])
ascii47 = ([1.0 3.0; 0.0 6.0],Array{Int64,1}[[1,2]])
ascii48 = ([4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0; 1.0 0.0 0.0 1.0 5.0 6.0 6.0 5.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[6,7],[7,8],[8,1],[4,8]])
ascii49 = ([0.0 2.0 2.0 0.0 4.0; 4.0 6.0 0.0 0.0 0.0],Array{Int64,1}[[1,2],[2,3],[4,5]])
ascii50 = ([0.0 0.0 1.0 3.0 4.0 4.0 0.0 4.0; 4.0 5.0 6.0 6.0 5.0 4.0 0.0 0.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[6,7],[7,8]])
ascii51 = ([0.0 4.0 2.0 4.0 4.0 3.0 1.0 0.0 0.0; 6.0 6.0 4.0 2.0 1.0 0.0 0.0 1.0 2.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[6,7],[7,8],[8,9]])
ascii52 = ([4.0 0.0 4.0 4.0; 1.0 1.0 6.0 0.0],Array{Int64,1}[[1,2],[2,3],[3,4]])
ascii53 = ([4.0 0.0 0.0 3.0 4.0 4.0 3.0 1.0 0.0 0.0; 6.0 6.0 4.0 4.0 3.0 1.0 0.0 0.0 1.0 2.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[6,7],[7,8],[8,9],[9,10]])
ascii54 = ([4.0 1.0 0.0 0.0 1.0 3.0 4.0 4.0 3.0 1.0 0.0; 6.0 6.0 5.0 1.0 0.0 0.0 1.0 3.0 4.0 4.0 3.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[6,7],[7,8],[8,9],[9,10],[10,11]])
ascii55 = ([0.0 0.0 4.0 0.0; 5.0 6.0 6.0 0.0],Array{Int64,1}[[1,2],[2,3],[3,4]])
ascii56 = ([1.0 3.0 4.0 4.0 3.0 1.0 0.0 0.0 4.0 4.0 3.0 1.0 0.0 0.0; 0.0 0.0 1.0 2.0 3.0 3.0 2.0 1.0 4.0 5.0 6.0 6.0 5.0 4.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[6,7],[7,8],[8,1],[6,5],[5,9],[9,10],[10,11],[11,12],[12,13],[13,14],[14,6]])
ascii57 = ([0.0 3.0 4.0 4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0; 0.0 0.0 1.0 5.0 6.0 6.0 5.0 3.0 2.0 2.0 3.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[6,7],[7,8],[8,9],[9,10],[10,11]])
ascii58 = ([2.0 2.0 1.5 1.5 2.0 2.0 1.5 1.5; 1.0 1.5 1.5 1.0 3.0 3.5 3.5 3.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,1],[5,6],[6,7],[7,8],[8,5]])
ascii59 = ([2.0 2.0 1.5 1.5 1.0 2.0 2.0 2.0 1.5 1.5; 3.0 3.5 3.5 3.0 -0.5 0.5 1.0 1.5 1.5 1.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,1],[5,6],[6,7],[7,8],[8,9],[9,10],[10,7]])
ascii60 = ([3.0 0.0 3.0; 6.0 3.0 0.0],Array{Int64,1}[[1,2],[2,3]])
ascii61 = ([1.0 3.0 1.0 3.0; 2.5 2.5 3.5 3.5],Array{Int64,1}[[1,2],[3,4]])
ascii62 = ([1.0 4.0 1.0; 6.0 3.0 0.0],Array{Int64,1}[[1,2],[2,3]])
ascii63 = ([2.0 2.0 1.5 1.5 1.75 1.75 3.0 3.0 2.0 1.0 0.0 0.0; 0.0 0.5 0.5 0.0 1.0 2.75 4.0 5.0 6.0 6.0 5.0 4.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,1],[5,6],[6,7],[7,8],[8,9],[9,10],[10,11],[11,12]])
ascii64 = ([4.0 1.0 0.0 0.0 1.0 3.0 4.0 4.0 2.0 1.0 2.0 3.0 2.0; 0.0 0.0 1.0 3.0 4.0 4.0 3.0 1.0 1.0 2.0 3.0 2.0 1.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[6,7],[7,8],[8,9],[9,10],[10,11],[11,12],[12,13]])
ascii65 = ([0.0 0.0 1.0 3.0 4.0 4.0 0.0 4.0; 0.0 5.0 6.0 6.0 5.0 0.0 2.0 2.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[7,8]])
ascii66 = ([0.0 0.0 3.0 4.0 4.0 3.0 4.0 4.0 3.0 0.0 0.0 3.0; 0.0 6.0 6.0 5.0 4.0 3.0 2.0 1.0 0.0 0.0 3.0 3.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[6,7],[7,8],[8,9],[9,10],[11,12]])
ascii67 = ([4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0; 1.0 0.0 0.0 1.0 5.0 6.0 6.0 5.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[6,7],[7,8]])
ascii68 = ([0.0 0.0 3.0 4.0 4.0 3.0 0.0; 0.0 6.0 6.0 5.0 1.0 0.0 0.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[6,7]])
ascii69 = ([4.0 0.0 0.0 4.0 0.0 3.0; 0.0 0.0 6.0 6.0 3.0 3.0],Array{Int64,1}[[1,2],[2,3],[3,4],[5,6]])
ascii70 = ([0.0 0.0 4.0 0.0 3.0; 0.0 6.0 6.0 3.0 3.0],Array{Int64,1}[[1,2],[2,3],[4,5]])
ascii71 = ([2.0 4.0 4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0; 3.0 3.0 1.0 0.0 0.0 1.0 5.0 6.0 6.0 5.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[6,7],[7,8],[8,9],[9,10]])
ascii72 = ([0.0 0.0 4.0 4.0 0.0 4.0; 0.0 6.0 6.0 0.0 3.0 3.0],Array{Int64,1}[[1,2],[3,4],[5,6]])
ascii73 = ([2.0 2.0 1.0 3.0 1.0 3.0; 0.0 6.0 0.0 0.0 6.0 6.0],Array{Int64,1}[[1,2],[3,4],[5,6]])
ascii74 = ([0.0 1.0 2.0 3.0 3.0 2.0 4.0; 1.0 0.0 0.0 1.0 6.0 6.0 6.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[6,7]])
ascii75 = ([4.0 0.0 4.0 0.0 0.0; 6.0 3.0 0.0 0.0 6.0],Array{Int64,1}[[1,2],[2,3],[4,5]])
ascii76 = ([4.0 0.0 0.0; 0.0 0.0 6.0],Array{Int64,1}[[1,2],[2,3]])
ascii77 = ([0.0 0.0 2.0 4.0 4.0; 0.0 6.0 4.0 6.0 0.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5]])
ascii78 = ([0.0 0.0 4.0 4.0 4.0; 0.0 6.0 2.0 0.0 6.0],Array{Int64,1}[[1,2],[2,3],[4,5]])
ascii79 = ([4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0 4.0; 1.0 0.0 0.0 1.0 5.0 6.0 6.0 5.0 1.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[6,7],[7,8],[8,9]])
ascii80 = ([0.0 0.0 3.0 4.0 4.0 3.0 0.0; 0.0 6.0 6.0 5.0 3.0 2.0 2.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[6,7]])
ascii81 = ([4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0 4.0 3.0 4.0; 1.0 0.0 0.0 1.0 5.0 6.0 6.0 5.0 1.0 1.0 0.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[6,7],[7,8],[8,9],[10,11]])
ascii82 = ([0.0 0.0 3.0 4.0 4.0 3.0 0.0 3.0 4.0; 0.0 6.0 6.0 5.0 3.0 2.0 2.0 2.0 0.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[6,7],[8,9]])
ascii83 = ([0.0 1.0 3.0 4.0 4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0; 1.0 0.0 0.0 1.0 2.0 3.0 3.0 4.0 5.0 6.0 6.0 5.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[6,7],[7,8],[8,9],[9,10],[10,11],[11,12]])
ascii84 = ([2.0 2.0 0.0 4.0; 0.0 6.0 6.0 6.0],Array{Int64,1}[[1,2],[3,4]])
ascii85 = ([0.0 0.0 1.0 3.0 4.0 4.0; 6.0 1.0 0.0 0.0 1.0 6.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6]])
ascii86 = ([0.0 2.0 4.0; 6.0 0.0 6.0],Array{Int64,1}[[1,2],[2,3]])
ascii87 = ([0.0 0.0 1.0 2.0 3.0 4.0 4.0; 6.0 3.0 0.0 3.0 0.0 3.0 6.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[6,7]])
ascii88 = ([0.0 4.0 0.0 4.0; 0.0 6.0 6.0 0.0],Array{Int64,1}[[1,2],[3,4]])
ascii89 = ([0.0 2.0 4.0 2.0 2.0; 6.0 2.0 6.0 2.0 0.0],Array{Int64,1}[[1,2],[2,3],[4,5]])
ascii90 = ([0.0 4.0 0.0 4.0; 6.0 6.0 0.0 0.0],Array{Int64,1}[[1,2],[2,3],[3,4]])
ascii91 = ([2.0 1.0 1.0 2.0; 0.0 0.0 6.0 6.0],Array{Int64,1}[[1,2],[2,3],[3,4]])
ascii92 = ([1.0 3.0; 6.0 0.0],Array{Int64,1}[[1,2]])
ascii93 = ([2.0 3.0 3.0 2.0; 0.0 0.0 6.0 6.0],Array{Int64,1}[[1,2],[2,3],[3,4]])
ascii94 = ([1.0 2.0 3.0; 5.0 6.0 5.0],Array{Int64,1}[[1,2],[2,3]])
ascii95 = ([1.0 4.0; 0.0 0.0],Array{Int64,1}[[1,2]])
ascii96 = ([2.0 2.0 3.0 2.5 2.5 2.0; 4.5 5.0 6.0 4.0 4.5 4.0],Array{Int64,1}[[1,2],[2,3],[4,5],[5,1],[1,6],[6,4]])
ascii97 = ([4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0 4.0 4.0; 1.0 0.0 0.0 1.0 2.0 3.0 3.0 2.0 0.0 3.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[6,7],[7,8],[8,1],[9,10]])
ascii98 = ([4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0 0.0 0.0 1.0; 1.0 0.0 0.0 1.0 2.0 3.0 3.0 2.0 0.0 5.0 5.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[6,7],[7,8],[8,1],[9,10],[10,11]])
ascii99 = ([4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0; 1.0 0.0 0.0 1.0 2.0 3.0 3.0 2.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[6,7],[7,8]])
ascii100 = ([4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0 4.0 4.0 3.0; 1.0 0.0 0.0 1.0 2.0 3.0 3.0 2.0 0.0 5.0 5.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[6,7],[7,8],[8,1],[9,10],[10,11]])
ascii101 = ([4.0 1.0 0.0 0.0 1.0 3.0 4.0 4.0 0.0; 0.0 0.0 1.0 2.0 3.0 3.0 2.0 1.0 1.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[6,7],[7,8],[8,9]])
ascii102 = ([4.0 4.0 3.0 2.0 1.0 1.0 0.0 2.0; 3.0 4.0 5.0 5.0 4.0 0.0 1.0 1.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[7,8]])
ascii103 = ([4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0 4.0 3.0 1.0 0.0; 1.0 0.0 0.0 1.0 2.0 3.0 3.0 2.0 0.0 -1.0 -1.0 0.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[6,7],[7,8],[8,1],[1,9],[9,10],[10,11],[11,12]])
ascii104 = ([4.0 4.0 3.0 1.0 0.0 0.0 0.0 1.0; 0.0 2.0 3.0 3.0 2.0 0.0 5.0 5.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[6,7],[7,8]])
ascii105 = ([1.0 3.0 1.0 3.0 2.0 2.0 2.25 2.25 1.75 1.75; 0.0 0.0 3.0 3.0 0.0 3.0 3.75 4.25 4.25 3.75],Array{Int64,1}[[1,2],[3,4],[5,6],[7,8],[8,9],[9,10],[10,7]])
ascii106 = ([1.0 3.0 2.0 2.0 1.0 0.0 2.25 2.25 1.75 1.75; 3.0 3.0 3.0 0.0 -1.0 0.0 3.75 4.25 4.25 3.75],Array{Int64,1}[[1,2],[3,4],[4,5],[5,6],[7,8],[8,9],[9,10],[10,7]])
ascii107 = ([0.0 1.0 1.0 0.0 4.0 2.0 1.0 3.0 4.0; 0.0 0.0 3.0 3.0 0.0 0.0 1.0 3.0 3.0],Array{Int64,1}[[1,2],[2,3],[3,4],[5,6],[6,7],[7,8],[8,9]])
ascii108 = ([2.0 2.0 1.0 1.0 3.0; 0.0 5.0 5.0 0.0 0.0],Array{Int64,1}[[1,2],[2,3],[4,5]])
ascii109 = ([4.0 4.0 2.0 2.0 2.0 0.0 0.0 0.0; 0.0 3.0 2.0 0.0 3.0 2.0 0.0 3.0],Array{Int64,1}[[1,2],[2,3],[4,5],[5,6],[7,8]])
ascii110 = ([3.0 3.0 1.0 1.0 1.0; 0.0 3.0 2.0 0.0 3.0],Array{Int64,1}[[1,2],[2,3],[4,5]])
ascii111 = ([4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0 4.0; 1.0 0.0 0.0 1.0 2.0 3.0 3.0 2.0 1.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[6,7],[7,8],[8,9]])
ascii112 = ([4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0 0.0 0.0; 1.0 0.0 0.0 1.0 2.0 3.0 3.0 2.0 3.0 -1.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[6,7],[7,8],[8,1],[9,10]])
ascii113 = ([4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0 4.0 4.0; 1.0 0.0 0.0 1.0 2.0 3.0 3.0 2.0 3.0 -1.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[6,7],[7,8],[8,1],[9,10]])
ascii114 = ([0.0 2.0 1.0 1.0 1.0 2.0 3.0 4.0; 0.0 0.0 0.0 3.0 2.0 3.0 3.0 2.0],Array{Int64,1}[[1,2],[3,4],[5,6],[6,7],[7,8]])
ascii115 = ([0.0 4.0 3.0 1.0 0.0 1.0 3.0 4.0; 0.0 0.0 1.0 1.0 2.0 3.0 3.0 2.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[6,7],[7,8]])
ascii116 = ([1.0 3.0 2.0 2.0 2.0 3.0; 0.0 0.0 0.0 5.0 4.0 4.0],Array{Int64,1}[[1,2],[3,4],[5,6]])
ascii117 = ([0.0 1.0 1.0 2.0 3.0 4.0 4.0; 3.0 3.0 1.0 0.0 0.0 1.0 3.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[6,7]])
ascii118 = ([0.0 1.0 3.0 4.0; 3.0 0.0 3.0 3.0],Array{Int64,1}[[1,2],[2,3],[3,4]])
ascii119 = ([0.0 0.0 1.0 2.0 3.0 4.0 4.0; 3.0 2.0 0.0 2.0 0.0 2.0 3.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[6,7]])
ascii120 = ([0.0 1.0 4.0 1.0 4.0; 3.0 3.0 0.0 0.0 3.0],Array{Int64,1}[[1,2],[2,3],[4,5]])
ascii121 = ([0.0 1.0 2.5 0.0 1.0 4.0; 3.0 3.0 1.5 0.0 0.0 3.0],Array{Int64,1}[[1,2],[2,3],[4,5],[5,6]])
ascii122 = ([0.0 0.0 3.0 0.0 3.0 4.0; 2.0 3.0 3.0 0.0 0.0 1.0],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6]])
ascii123 = ([2.5 2.0 2.0 1.5 2.0 2.0 2.5; 6.5 6.0 3.5 3.0 2.5 0.0 -0.5],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[6,7]])
ascii124 = ([2.0 2.0; 0.0 5.0],Array{Int64,1}[[1,2]])
ascii125 = ([1.5 2.0 2.0 2.5 2.0 2.0 1.5; 6.5 6.0 3.5 3.0 2.5 0.0 -0.5],Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[6,7]])
ascii126 = ([1.0 1.75 2.75 3.5; 5.0 5.5 5.0 5.5],Array{Int64,1}[[1,2],[2,3],[3,4]])


""" 
	hpcs::Array


"""
hpcs = [ 
	ascii32,ascii33,ascii34,ascii35,ascii36,ascii37,ascii38,ascii39,ascii40,ascii41,
	ascii42,ascii43,ascii44,ascii45,ascii46,ascii47,ascii48,ascii49,ascii50,ascii51,
	ascii52,ascii53,ascii54,ascii55,ascii56,ascii57,ascii58,ascii59,ascii60,ascii61,
	ascii62,ascii63,ascii64,ascii65,ascii66,ascii67,ascii68,ascii69,ascii70,ascii71,
	ascii72,ascii73,ascii74,ascii75,ascii76,ascii77,ascii78,ascii79,ascii80,ascii81,
	ascii82,ascii83,ascii84,ascii85,ascii86,ascii87,ascii88,ascii89,ascii90,ascii91,
	ascii92,ascii93,ascii94,ascii95,ascii96,ascii97,ascii98,ascii99,ascii100,ascii101,
	ascii102,ascii103,ascii104,ascii105,ascii106,ascii107,ascii108,ascii109,ascii110,ascii111,
	ascii112,ascii113,ascii114,ascii115,ascii116,ascii117,ascii118,ascii119,ascii120,ascii121,
	ascii122,ascii123,ascii124,ascii125,ascii126 ]


#	
const textalignment = "centre" #default value
const textangle = pi/4 #default value
const textwidth = 1.0 #default value
const textheight = 1.0 #default value
const textspacing = 0.25 #default value
const fontwidth = 4.0 #default value
const fontheight = 8.0 #default value
const fontspacing = 1.0 #default value


""" 
	charpols(charlist)


"""
function charpols(charlist)
    return [hpcs[code] for code in [Int(char[1])-31 for char in charlist]]
end



""" 
	charseq(string)


"""
function charseq(string)
	return [string[i] for i=1:length(string)]
end


""" 
	text(strand::String)::LAR


"""
function text(strand)
	out = comp([ L.struct2lar, L.Struct, cat, distr,
			cons([ charpols, k(L.t(fontspacing+fontwidth,0)) ]),charseq ])(strand)
	return out
end



""" 
	a2a(mat)


"""
function a2a(mat)
	function a2a0(models)
		assembly = []
		for model in models
			push!( assembly, LARLIB.Struct([ mat,model ]) )
		end
		assembly
	end
	return a2a0
end


""" 
	translate(c)(lar)


"""
function translate(c)
	function translate0(lar) 
		xs = lar[1][1,:]
		width = maximum(xs) - minimum(xs)
		apply(L.t(width/c,0))(lar)
	end
	return translate0
end


""" 
	align(textalignment="centre")


"""
function align(textalignment="centre")
	function align1(model)
		if ( textalignment == "centre" ) out=translate(-2)(model)
		elseif ( textalignment == "right" ) out=translate(-1)(model)
		elseif ( textalignment == "left" ) out=model 
		end
		return out
	end
end



""" 
	textWithAttributes(textalignment='centre', textangle=0, 
		textwidth=1.0, textheight=2.0, textspacing=0.25)(strand::String)::LAR


"""
function textWithAttributes(textalignment="centre", textangle=0, 
							textwidth=1.0, textheight=2.0, textspacing=0.25) 
	function textWithAttributes(strand)
		id = x->x
		mat = LARLIB.s(textwidth/fontwidth,textheight/fontheight)
		comp([ 
		   apply(LARLIB.r(textangle)),
		   align(textalignment),
		   L.struct2lar,
		   L.Struct,
		   cat,
		   distr,
		   cons([ a2a(mat) ∘ charpols, 
				k(LARLIB.t(textwidth+textspacing,0)) ]),
		   charseq ])(strand)
	end
end
 





#function array2list(cells) 
#return PyObject([Any[cell[h] for h=1:length(cell)] for cell in cells])
#end
#
#function doublefirst(cells)
#return p.AL([cells[1],cells])
#end
#
## LAR `model` ->  numbered `HPC` obyect
#function lar2numbered_hpc(larmodel,scaling=1.0)
#	V,cells = larmodel
#	VV,EV,FV,CV = cells
#
#	Z = hcat(V[:,1],V)
#	W = PyCall.PyObject([Any[Z[h,k] for h=1:size(Z,1)] for k=1:size(Z,2)])
#
#	VV,EV,FV,CV = map(doublefirst,[VV+1,EV+1,FV+1,CV+1])
#	WW,EW,FW,CW = map(array2list,[VV,EV,FV,CV])
#	PyCall.PyObject([WW,EW,FW,CW])
#	wire = p.MKPOL(PyCall.PyObject([W,EW,[]]))
#
#	VV,EV,FV,CV = VV-1,EV-1,FV-1,CV-1
#	WW,EW,FW,CW = map(array2list,[VV,EV,FV,CV])
#	hpc = p.larModelNumbering(1,1,1)(W,PyCall.PyObject([WW,EW,FW,CW]),wire,scaling)
#end
#
#
## Display a numbered `HPC` object from a `LAR` model with the `PyPlasm` viewer
#viewnumbered(larmodel,scaling=1.0) = p.VIEW(lar2numbered_hpc(larmodel,scaling))
#
#def cellNumbering (larModel,hpcModel):
#V,CV = larModel
#def cellNumbering0 (cellSubset,color=WHITE,scalingFactor=1):
#	text = TEXTWITHATTRIBUTES (TEXTALIGNMENT='centre',TEXTANGLE=0,
#						TEXTWIDTH=0.1*scalingFactor,
#						TEXTHEIGHT=0.2*scalingFactor,
#						TEXTSPACING=0.025*scalingFactor)
#	hpcList = [hpcModel]
#	for cell in cellSubset:
#		point = CCOMB([V[v] for v in CV[cell]])
#		hpcList.append(T([1,2,3])(point)(COLOR(color)(text(str(cell)))))
#	return STRUCT(hpcList)
#return cellNumbering0
#
#def modelIndexing(shape):
#   V,bases = larCuboids(shape,True)
#   # bases = [[cell for cell in cellComplex if len(cell)==2**k] for k in range(4)]
#   color = [ORANGE,CYAN,GREEN,WHITE]
#   nums = AA(range)(AA(len)(bases))
#   hpcs = []
#   for k in range(4):
#       hpcs += [SKEL_1(STRUCT(MKPOLS((V,bases[k]))))]
#       hpcs += [cellNumbering((V,bases[k]),hpcs[2*k])(nums[k],color[k],0.3+0.2*k)]
#   return STRUCT(hpcs)
#
#def larModelNumbering(scalx=1,scaly=1,scalz=1):
#   def  larModelNumbering0(V,bases,submodel,numberScaling=1):
#       color = [ORANGE,CYAN,GREEN,WHITE]
#       nums = AA(range)(AA(len)(bases))
#       hpcs = [submodel]
#       for k in range(len(bases)):
#           hpcs += [cellNumbering((V,bases[k]),submodel)
#                       (nums[k],color[k],(0.5+0.1*k)*numberScaling)]
#       return STRUCT(hpcs)
#       #return EXPLODE(scalx,scaly,scalz)(hpcs)
#   return larModelNumbering0
#
#
