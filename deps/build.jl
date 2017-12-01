try
   Pkg.installed("LARLIB")
catch
   Pkg.clone("https://github.com/cvdlab/LARLIB.jl.git")
   Pkg.build("LARLIB")
end
