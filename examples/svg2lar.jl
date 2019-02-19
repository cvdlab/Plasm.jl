using LinearAlgebraicRepresentation
Lar = LinearAlgebraicRepresentation
using Plasm

function show(filename)
	V, EV = Plasm.svg2lar(filename)
	Plasm.view(Plasm.numbering(.2)((V,[[[k] for k=1:size(V,2)], EV])))
	V, EV = Plasm.svg2lar(filename, flag=false)
	Plasm.view(Plasm.numbering(2)((V,[[[k] for k=1:size(V,2)], EV])))
end

show("/Users/paoluzzi/Documents/dev/Plasm.jl/test/svg/curved.svg")
show("/Users/paoluzzi/Documents/dev/Plasm.jl/test/svg/twopaths.svg")
show("/Users/paoluzzi/Documents/dev/Plasm.jl/test/svg/paths.svg")
show("/Users/paoluzzi/Documents/dev/Plasm.jl/test/svg/boundarytest2.svg")
show("/Users/paoluzzi/Documents/dev/Plasm.jl/test/svg/tile.svg")
show("/Users/paoluzzi/Documents/dev/Plasm.jl/test/svg/interior.svg")
