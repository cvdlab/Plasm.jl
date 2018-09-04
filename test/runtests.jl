using Test
using LinearAlgebraicRepresentation
using DataStructures

using PyCall
p = PyCall.pyimport("pyplasm")
p_STRUCT = p["STRUCT"]
p_MKPOL = p["MKPOL"]
p_VIEW = p["VIEW"]

using Plasm

include("./views.jl")
include("./graphic_text.jl")
