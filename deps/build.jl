try
   Pkg.installed("LinearAlgebraicRepresentation")
catch
   Pkg.clone("https://github.com/cvdlab/LinearAlgebraicRepresentation.jl.git")
   Pkg.build("LinearAlgebraicRepresentation")
end
