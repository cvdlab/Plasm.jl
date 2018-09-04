using LinearAlgebraicRepresentation
L = LinearAlgebraicRepresentation

using PyCall
p = PyCall.pyimport("pyplasm")
p_STRUCT = p["STRUCT"]
p_MKPOL = p["MKPOL"]
p_VIEW = p["VIEW"]

using Plasm

square = ([[0; 0] [0; 1] [1; 0] [1; 1]], [[1, 2, 3, 4]], 
[[1,2], [1,3], [2,4], [3,4]])
V,FV,EV  =  square

function mkpol(verts::L.Points, cells::L.Cells)::Plasm.Hpc
   verts = Plasm.points2py(verts)
   cells = Plasm.cells2py(cells)
   return p_MKPOL([verts,cells,[]])
end

hpc = mkpol(V,EV)
p_VIEW(hpc)