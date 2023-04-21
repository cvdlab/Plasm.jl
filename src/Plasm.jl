
module Plasm

#export centroid, cuboidGrid, mkpol, view, hpc_exploded, lar2hpc

using LinearAlgebraicRepresentation
Lar = LinearAlgebraicRepresentation
using DataStructures
using SparseArrays
using PyCall

p = pyimport("pyplasm")

import Base.view


"""
	Points = Matrix

Alias declation of LAR-specific data structure.
Dense `Matrix` ``M times N`` to store the position of *vertices* (0-cells)
of a *cellular complex*. The number of rows ``M`` is the dimension
of the embedding space. The number of columns ``N`` is the number of vertices.
"""
const Points = Matrix


"""
	Cells = Array{Array{Int,1},1}

Alias declation of LAR-specific data structure.
Dense `Array` to store the indices of vertices of `P-cells`
of a cellular complex.
The linear space of `P-chains` is generated by `Cells` as a basis.
Simplicial `P-chains` have `P+1` vertex indices for `cell` element in `Cells` array.
Cuboidal `P-chains` have ``2^P`` vertex indices for `cell` element in `Cells` array.
Other types of chain spaces may have different numbers of vertex indices for `cell`
element in `Cells` array.
"""
const Cells = Array{Array{Int,1},1}


"""
	Chain = SparseVector{Int8,Int}

Alias declation of LAR-specific data structure.
Binary `SparseVector` to store the coordinates of a `chain` of `N-cells`. It is
`nnz=1` with `value=1` for the coordinates of an *elementary N-chain*, constituted by
a single *N-chain*.
"""
const Chain = SparseVector{Int8,Int}


"""
	ChainOp = SparseMatrixCSC{Int8,Int}

Alias declation of LAR-specific data structure.
`SparseMatrix` in *Compressed Sparse Column* format, contains the coordinate
representation of an operator between linear spaces of `P-chains`.
Operators ``P-Boundary : P-Chain -> (P-1)-Chain``
and ``P-Coboundary : P-Chain -> (P+1)-Chain`` are typically stored as
`ChainOp` with elements in ``{-1,0,1}`` or in ``{0,1}``, for
*signed* and *unsigned* operators, respectively.
"""
const ChainOp = SparseMatrixCSC{Int8,Int}


"""
	ChainComplex = Array{ChainOp,1}

Alias declation of LAR-specific data structure. It is a
1-dimensional `Array` of `ChainOp` that provides storage for either the
*chain of boundaries* (from `D` to `0`) or the transposed *chain of coboundaries*
(from `0` to `D`), with `D` the dimension of the embedding space, which may be either
``R^2`` or ``R^3``.
"""
const ChainComplex = Array{ChainOp,1}


"""
	LARmodel = Tuple{Points,Array{Cells,1}}

Alias declation of LAR-specific data structure.
`LARmodel` is a pair (*Geometry*, *Topology*), where *Geometry* is stored as
`Points`, and *Topology* is stored as `Array` of `Cells`. The number of `Cells`
values may vary from `1` to `N+1`.
"""
const LARmodel = Tuple{Points,Array{Cells,1}}


"""
	LAR = Tuple{Points,Cells}

Alias declation of LAR-specific data structure.
`LAR` is a pair (*Geometry*, *Topology*), where *Geometry* is stored as
`Points`, and *Topology* is stored as `Cells`.
"""
const LAR = Tuple{Points,Cells}


"""
	Hpc = PyCall.PyObject

Alias declation of LAR-specific data structure.
`Hpc` stands for *Hierarchical Polyhedral Complex* and is the geometric data structure
used by `PLaSM` (Programming LAnguage for Solid Modeling). See the Wiley's book
[*Geometric Programming for Computer-Aided Design*]
(https://onlinelibrary.wiley.com/doi/book/10.1002/0470013885) and its
current `Python` library [*https://github.com/plasm-language/pyplasm*]
(https://github.com/plasm-language/pyplasm).
"""
const Hpc = PyCall.PyObject




"""
	const color::OrderedDict(String,PyObject)

Dictionary of predefined `color::PyObject` functions, with `string` keys and
`PyObject` value, usable as Julia functions of type `Hpc -> Hpc`.
Notice that in order to be visualized by `PyPlasm` viewer, color functions must
be applied to `Hpc` values, and return `Hpc` values.

# Example

```julia
julia> julia> @show keys(colors);
keys(colors) = ["orange", "red", "green", "blue", "cyan", "magenta",
				"yellow", "white", "black", "purple", "gray", "brown"]

julia> green = colors.green

julia> V,CV = Lar.cuboid([1,4,9])
([0.0 0.0 … 1.0 1.0; 0.0 0.0 … 4.0 4.0; 0.0 9.0 … 0.0 9.0], Array{Int64,1}[[1, 2, 3, 4, 5, 6, 7, 8]])

julia> hpc = Plasm.lar2hpc(V,CV)
PyObject <pyplasm.xgepy.Hpc; proxy of <Swig Object of type 'std::shared_ptr< Hpc > *' at 0x12943c690> >

julia> green(hpc)
PyObject <pyplasm.xgepy.Hpc; proxy of <Swig Object of type 'std::shared_ptr< Hpc > *' at 0x12943c6c0> >

julia> Plasm.view(Plasm.green(hpc))
```
"""
function color(key::String)::PyObject
	p = PyCall.pyimport("pyplasm")
	colors = OrderedDict([
	"white" => p.COLOR(p.WHITE),
	"red" => p.COLOR(p.RED),
	"green" => p.COLOR(p.GREEN),
	"blue" => p.COLOR(p.BLUE),
	"cyan" => p.COLOR(p.CYAN),
	"magenta" => p.COLOR(p.MAGENTA),
	"yellow" => p.COLOR(p.YELLOW),
	"black" => p.COLOR(p.BLACK),
	"orange" => p.COLOR(p.ORANGE),
	"purple" => p.COLOR(p.PURPLE),
	"gray" => p.COLOR(p.GRAY),
	"brown" => p.COLOR(p.BROWN) ])
	return  colors[key]
end

const colorkey = ["white", "red", "green", "blue", "cyan", "magenta", "yellow",
	"black", "orange", "purple", "gray", "brown"]


"""
	Color4f

`PyObject` <function COLOR at 0x126d6f730>

# Example

```julia
julia> black = Color4f(0,0,0,1)
PyObject Color4f(0.000000e+00,0.000000e+00,0.000000e+00,1.000000e+00)

julia> b = color(black)
PyObject <function COLOR.<locals>.COLOR0 at 0x135dfcb70>

julia> white = Color4f(1,1,1,1)
PyObject Color4f(1.000000e+00,1.000000e+00,1.000000e+00,1.000000e+00)

julia> w = color(white)
PyObject <function COLOR.<locals>.COLOR0 at 0x135dfcc80>
```
"""
function Color4f(red::Number, green::Number, blue::Number, alpha::Number)::PyCall.PyObject
	p = PyCall.pyimport("pyplasm")
	return p.Color4f(red, green, blue, alpha)
end


"""
	Color(color4f::PyCall.PyObject)::PyCall.PyObject

Generate an object of type `PyObject Color4f()` to be used with `pyplasm` package.

# Example

```julia
julia> black = Plasm.Color4f(0,0,0,1)
PyObject Color4f(0.000000e+00,0.000000e+00,0.000000e+00,1.000000e+00)

julia> b = color(black)
PyObject <function COLOR.<locals>.COLOR0 at 0x135dfcb70>

julia> white = Plasm.Color4f(1,1,1,1)
PyObject Color4f(1.000000e+00,1.000000e+00,1.000000e+00,1.000000e+00)

julia> w = Plasm.color(white)
PyObject <function COLOR.<locals>.COLOR0 at 0x135dfcc80>
```
"""
function Color(color4f::PyCall.PyObject)::PyCall.PyObject
	p = PyCall.pyimport("pyplasm")
	return p.COLOR(color4f)
end

#function color(mycolor::"String", model::Lar.LAR)::PyCall.PyObject
#	p = PyCall.pyimport("pyplasm")
#	hpc = lar2hpc(model)
#	return color(mycolor)(hpc)
#end

include("./fenvs.jl")
include("./views.jl")
include("./graphic_text.jl")
include("./utilities.jl")

#include("./viewer/Viewer.jl")

end # module
