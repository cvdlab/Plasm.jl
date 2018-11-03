using LinearAlgebraicRepresentation
Lar = LinearAlgebraicRepresentation
using Plasm
View = Plasm.view

# input of 2-skeleton (planar graph)
V = [9. 13 15 17 14 13 11 9 7 5 3 0 2 2 5 7 4 12 6 8 3 5 7 8 10 11 10 13 14 13 11 9 7 4 2 12 12; 0 2 4 8 9 10 11 10 9 9 8 6 3 1 0 1 2 10 3 3 5 5 6 5 5 4 2 4 6 7 9 7 7 7 6 7 5]

EV = Array{Int64,1}[[1, 2], [1, 16], [1, 27], [2, 3], [2, 27], [2, 28], [3, 4], [3, 29], [4, 5], [4, 29], [5, 6], [5, 29], [5, 30], [6, 7], [6, 18], [7, 8], [7, 18], [8, 9], [8, 31], [8, 32], [9, 10], [9, 33], [10, 11], [10, 34], [11, 12], [11, 34], [12, 13], [12, 21], [12, 35], [13, 14], [13, 17], [13, 21], [14, 15], [14, 17], [15, 16], [15, 17], [16, 20], [16, 27], [17, 19], [18, 31], [19, 20], [19, 22], [19, 23], [19, 24], [20, 24], [20, 25], [21, 22], [21, 34], [21, 35], [22, 23], [22, 33], [23, 24], [23, 33], [24, 25], [24, 32], [25, 26], [25, 27], [25, 32], [25, 36], [26, 27], [26, 28], [26, 37], [28, 29], [28, 37], [29, 30], [29, 37], [30, 36], [31, 32], [31, 36], [32, 33], [33, 34], [34, 35], [36, 37]]

# computation of 2D cell complex (planar arrangement)
V,(EV,FV),(copEV,copFE) = chaincomplex( V, EV )

# visualization
VV = [[k] for k=1:size(V,2)]
model = (V, (VV,EV,FV))
View(Plasm.numbering(2.)(model))
View(Plasm.hpc_exploded( model )(1.5,1.5,1.5))
