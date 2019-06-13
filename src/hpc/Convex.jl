using LinearAlgebraicRepresentation
Lar = LinearAlgebraicRepresentation
using QHull
using Plasm, Revise
GL = Plasm

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

GL.VIEW([
      GL.GLCuboid(GL.Box3d(GL.Point3d(0,0,0),GL.Point3d(1,1,1)))
      GL.GLAxis(GL.Point3d(-2,-2,-2),GL.Point3d(+2,+2,+2))
      ])
