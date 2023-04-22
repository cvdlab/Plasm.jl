# Plasm.jl

Graphics module to visualize [LinearAlgebraicRepresentation.jl](https://github.com/cvdlab/LinearAlgebraicRepresentation.jl) structures via PyPLaSM python package.

### Version
0.1.0

## Installing

Follow the simple README instructions, depending on your Python installation, to install `pyplasm` from [https://github.com/plasm-language/pyplasm](https://github.com/plasm-language/pyplasm) repo.

In a Julia console:

```
using Pkg
Pkg.add(PackageSpec(url="https://github.com/cvdlab/Plasm.jl", rev="master")) 
using Plasm
```

## API

Include the module (`using Plasm`).

## Authors
* [Giorgio Scorzelli](https://github.com/plasm-language/pyplasm)
* [Alberto Paoluzzi](https://github.com/apaoluzzi)
* [Francesco Furiani](https://github.com/furio)

## How to contribute

Fork this repo and send a pull request.


## Developers only


Setup for windows (change path as needed):

```
"C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build\vcvars64.bat"
c:\Julia-1.8.5\bin\julia.exe
```

Test pyplasm:

```
using Pkg
Pkg.add("PyCall")
Pkg.build("PyCall")
Pkg.build("Conda")
using PyCall 
@pyimport math     
print(math.sin(90))
using Conda
Conda.add("pyplasm",channel="scrgiorgio") 
@pyimport pyplasm  
pyplasm.VIEW(pyplasm.CUBOID([1,1,1]))
```


Test all packages:
- see https://github.com/cvdlab/Plasm.jl
- see https://juliahub.com/ui/Packages

```
using Pkg

Pkg.add("ModernGL")
using ModernGL

Pkg.add("GLFW")
using GLFW

Pkg.add("PyCall")
using PyCall

Pkg.add("IntervalTrees")
using IntervalTrees

Pkg.add("SparseArrays")
using SparseArrays

Pkg.add("Revise")
using Revise

Pkg.add("NearestNeighbors")
using NearestNeighbors

Pkg.add("DataStructures")
using DataStructures

Pkg.add("LinearAlgebra")
using LinearAlgebra

Pkg.add(PackageSpec(url="https://github.com/cvdlab/Triangle.jl", rev="master")) 
Pkg.build("Triangle")
using Triangle

Pkg.add(PackageSpec(url="https://github.com/cvdlab/LinearAlgebraicRepresentation.jl", rev="master")) 
Pkg.build("LinearAlgebraicRepresentation")
using LinearAlgebraicRepresentation

Pkg.add(PackageSpec(url="https://github.com/cvdlab/Plasm.jl", rev="master")) 
Pkg.build("Plasm")
using Plasm

```

