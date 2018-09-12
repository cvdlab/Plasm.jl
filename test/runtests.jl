using Test
using LinearAlgebraicRepresentation
using DataStructures

using PyCall
p = PyCall.pyimport("pyplasm")

using Plasm

include("./views.jl")
include("./graphic_text.jl")
