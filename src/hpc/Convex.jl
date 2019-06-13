using LinearAlgebraicRepresentation
Lar = LinearAlgebraicRepresentation
using QHull
using Plasm, Revise

p = rand(10,2)
ch = chull(p)
ch.points         # original points
ch.vertices       # indices to line segments forming the convex hull
ch.simplices      # the simplexes forming the convex hull
show(ch)

V = Lar.cuboid([-0.5, -0.5, -0.5])[1]
p = convert(Array{Float64,2}, V')
FV = chull(p).simplices
Plasm.view(V,FV)
