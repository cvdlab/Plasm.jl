using LARVIEW
using PyCall
@pyimport larlib as p
include("../src/utilities.jl")

V,(VV,EV,FV,CV) = LARLIB.larCuboids([3,2,1],true)
larmodel = V,(VV,EV,FV,CV)
LARVIEW.viewnumbered(larmodel)