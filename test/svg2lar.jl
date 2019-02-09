using Plasm
using LinearAlgebraicRepresentation
Lar = LinearAlgebraicRepresentation
using DataStructures
using PyCall
p = PyCall.pyimport("pyplasm")


"""
	svg2lines(filename::String; normalize=true)::Lar.LAR

Parse a SVG file to a `LAR` model `(V,EV)`.
Only  `<line >` and `<rect >` SVG primitives are currently translated. 
TODO:  interpretation of `<path >` and transformations.
"""
function svg2lines(filename::String; normalize=true)::Lar.LAR
	outlines = Array{Float64,1}[]
	for line in eachline(filename)
		parts = split(line, ' ')
		# SVG <line > primitives
		if parts[1] == "<line"
			regex = r"""(<line )(.+)(" x1=")(.+)(" y1=")(.+)(" x2=")(.+)(" y2=")(.+)("/>)"""
			coords = collect(match( regex , line)[k] for k in (4,6,8,10))
			outline = [ parse(Float64, string) for string in coords ]
			push!(outlines, outline)
		# SVG <rect > primitives
		elseif parts[1] == "<rect"
			regex = r"""(<rect x=")(.+?)(" y=")(.+?)(" )(.*?)( width=")(.+?)(" height=")(.+?)("/>)"""
			coords = collect(match( regex , line)[k] for k in (2,4,8,10))
			x, y, width, height = [ parse(Float64, string) for string in coords ]
			line1 = [ x, y, x+width, y ]
			line2 = [ x, y, x, y+height ]
			line3 = [ x+width, y, x+width, y+height ]
			line4 = [ x, y+height, x+width, y+height ]
			push!(outlines, line1, line2, line3, line4)
		# SVG <rect > primitives (TODO)
		# see https://github.com/regebro/svg.path
		end
	end
	lines = hcat(outlines...)
	lines = map( x->round(x,sigdigits=8), lines )
	vertdict = OrderedDict{Array{Float64,1}, Int64}()
	EV = Array{Int64,1}[]
	idx = 0
	for h=1:size(lines,2)
		x1,y1,x2,y2 = lines[:,h]
		
		if ! haskey(vertdict, [x1,y1])
			idx += 1
			vertdict[[x1,y1]] = idx
		end
		if ! haskey(vertdict, [x2,y2])
			idx += 1
			vertdict[[x2,y2]] = idx
		end
		v1,v2 = vertdict[[x1,y1]],vertdict[[x2,y2]]
		push!(EV, [v1,v2])
	end
	V = hcat(collect(keys(vertdict))...) 
#	ymax = maximum(V[2,:])
#	V[1,:] = V[1,:] .+ 0
#	V[2,:] = -V[2,:] .+ ymax
#	V = map( x->round(x,sigdigits=8), V )
	
	xmin = minimum(V[1,:]); ymin = minimum(V[2,:]); 
	xmax = maximum(V[1,:]); ymax = maximum(V[2,:]); 
	box = [[xmin; ymin] [xmax; ymax]]
	if normalize
		T = Lar.t(0,1) * Lar.s(1,-1) * Lar.s(1/(xmax-xmin), 1/(ymax-ymin)) * Lar.t(-xmin,-ymin) 
	else
		T = Lar.t(0, ymax-ymin) * Lar.s(1,-1)
	end
	W = T[1:2,:] * [V;ones(1,size(V,2))]
	V = map( x->round(x,sigdigits=8), W )
	return V,EV
end

filename = "/Users/paoluzzi/Documents/dev/Plasm.jl/test/svg/boundarytest2.svg"
V, EV = svg2lines(filename)
Plasm.view(Plasm.numbering(.2)((V,[[[k] for k=1:size(V,2)], EV])))
V, EV = svg2lines(filename, normalize=false)
Plasm.view(Plasm.numbering(.2)((V,[[[k] for k=1:size(V,2)], EV])))

filename = "/Users/paoluzzi/Documents/dev/Plasm.jl/test/svg/tile.svg"
V, EV = svg2lines(filename)
Plasm.view(Plasm.numbering(.2)((V,[[[k] for k=1:size(V,2)], EV])))
V, EV = svg2lines(filename, normalize=false)
Plasm.view(Plasm.numbering(.2)((V,[[[k] for k=1:size(V,2)], EV])))

