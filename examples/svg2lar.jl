using Plasm
using LinearAlgebraicRepresentation
Lar = LinearAlgebraicRepresentation


filename = "/Users/paoluzzi/Documents/dev/Plasm.jl/test/svg/path.svg"
V, EV = Plasm.svg2lar(filename)
Plasm.view(Plasm.numbering(.2)((V,[[[k] for k=1:size(V,2)], EV])))
V, EV = Plasm.svg2lar(filename, normalize=false)
Plasm.view(Plasm.numbering(.2)((V,[[[k] for k=1:size(V,2)], EV])))

filename = "/Users/paoluzzi/Documents/dev/Plasm.jl/test/svg/boundarytest2.svg"
V, EV = Plasm.svg2lar(filename)
Plasm.view(Plasm.numbering(.2)((V,[[[k] for k=1:size(V,2)], EV])))
V, EV = Plasm.svg2lar(filename, normalize=false)
Plasm.view(Plasm.numbering(.2)((V,[[[k] for k=1:size(V,2)], EV])))

filename = "/Users/paoluzzi/Documents/dev/Plasm.jl/test/svg/tile.svg"
V, EV = Plasm.svg2lar(filename)
Plasm.view(Plasm.numbering(.2)((V,[[[k] for k=1:size(V,2)], EV])))
V, EV = Plasm.svg2lar(filename, normalize=false)
Plasm.view(Plasm.numbering(.2)((V,[[[k] for k=1:size(V,2)], EV])))

filename = "/Users/paoluzzi/Documents/dev/Plasm.jl/test/svg/interior.svg"
V, EV = Plasm.svg2lar(filename)
Plasm.view(V, EV)

filename = "/Users/paoluzzi/Documents/dev/Plasm.jl/test/svg/howto.svg"
V, EV = Plasm.svg2lar(filename)
Plasm.view(Plasm.numbering(.2)((V,[[[k] for k=1:size(V,2)], EV])))
