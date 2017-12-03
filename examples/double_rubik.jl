using LARVIEW

V,cells = LARLIB.larCuboids([3,3,3],true)
FV = cells[3]
V = convert(Array{Float64,2}, V)
LARVIEW.viewexploded(V,FV);

V = LARVIEW.translate([-1.5,-1.5,-1.5],V)
LARVIEW.viewexploded(V,FV);
V = LARVIEW.scale([.25,.25,.25],V)
LARVIEW.viewexploded(V,FV);

W = copy(V)
FW = copy(FV)

W = LARVIEW.rotate((0,π/3,0),LARVIEW.rotate((π/3,0,0), W))
LARVIEW.viewexploded(W,FW);

larmodel = V,cells
LARVIEW.viewnumbered(larmodel,.25)
