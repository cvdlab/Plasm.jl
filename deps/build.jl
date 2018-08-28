try
   Pkg.installed("LARLIB")
catch
   Pkg.clone("https://github.com/cvdlab/LinearAlgebraicRepresentation.jl.git")
   Pkg.build("LARLIB")
end
