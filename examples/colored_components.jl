using Plasm
using LinearAlgebraicRepresentation
Lar = LinearAlgebraicRepresentation
using DataStructures

(V, EV) = ([0.4147 0.3513 1.0727 1.0207 0.9985 0.9819 0.9589 0.9551 0.2472 0.3382 0.412 0.6323 0.6883 0.6905 0.7134 0.7493 0.9692 0.96975 0.97765 0.98495 0.98675 1.0061 1.0118 1.0196 1.0212 0.7513 0.8803 0.9053 1.1325 0.8074 0.7588 0.8152 1.0346 1.071 1.2059 1.145 1.12855 1.1198 1.0817 1.0793 0.9135 0.894 0.8909 0.5633 0.5419 0.5337 0.8759 0.8777 0.8805 0.6816 0.678 0.67025 0.6533 0.6396 0.6011 0.5156 0.4937 0.4369 0.3842 0.1423 0.188 0.3885 0.3111 0.3739 0.5279 0.6445 0.4494 0.4046 0.3577 0.5681 0.6194 0.6245 0.6312 0.6457 0.7953 0.7642 0.4687 0.5068 0.4716 0.4184 0.9952 0.9689 0.8672 0.8052 0.8873 1.0581 0.7346 0.6812 0.6802 0.6416 0.5996 0.2089 0.1971 0.1637 0.5901 0.6027 0.6054 0.6599 0.6653 0.6873 0.8794 0.8735 0.8456 0.8338 1.0287 0.9359 0.9698 0.9867 1.0316 1.0844 1.1472 1.192 1.1772 1.1558 1.116 0.9926 1.0564 0.8367 0.6039 0.5565 0.7989 0.868 0.8747 0.8885 0.8912 1.1651 1.2045 1.2104 1.0543 1.039 1.0099 0.4669 0.6515 0.6552 0.6721 0.6753 0.7547 0.7621 0.995 1.0185 1.1216 1.1358 0.1423 0.1606 0.1941 0.5786 0.4388 0.8556 0.8585 0.9516 1.0371 1.1562 0.396 0.3752 1.0705 1.09785 1.1442 1.1637 0.3416 0.2369 0.0492 0.0 1.2505 1.0215 0.9192 0.944 0.9664 1.0162 0.4171 0.3993 0.3606 0.254 0.2095 0.0984 1.2328 1.1039 1.033 1.0084 0.3604 0.3398 0.2462 0.2247 0.2226 0.042 0.5514 0.5684 0.5978 0.66255 0.664 0.6678 0.742 0.4943 0.5545 0.579 0.5919 0.225 0.2006 0.194 0.2391 0.2201 0.7876 0.7645 0.756 0.7482 0.5815 0.5367 0.5016 0.4217 0.3506 0.3548 0.3662 1.0513 0.965 0.9079 0.7189 0.7069 0.6592 0.6005 0.4101 0.4085 0.3773 1.0137 1.00855 0.8911 0.7751 0.7739 0.7613 0.5301 0.4518 0.3103 1.0211 1.1883 1.2607 1.0758 1.0546 1.0327 0.89135 0.8844 0.9508 0.9783 0.9904 1.0214 0.8913 0.8323 0.9119 0.7358 0.7209 0.5202 0.9087 0.8283 1.2488 0.9538 1.1125 0.9496 0.8673 0.4435 0.688 0.7065 0.9402 1.0538 1.0825 1.33 0.6925 0.7525 0.8367 0.3249 0.2557 0.1853 0.9102 1.00805 1.1588 0.6854 0.6691 0.555 0.2412 0.2551 0.2636 0.4074 0.5142 0.3093 0.1165 1.0201 0.7699 0.7295 0.7237 0.8186 0.6238 0.3453 0.3965 0.7716 0.704 0.8378 0.7839 0.6726 0.6944 0.6354 0.8668 0.8745 0.8808 0.9726 1.1682 0.4632 0.419 0.6471 0.6784 0.8065 0.4551 0.7609 0.859 0.7564 1.1209 0.8271 0.54 0.715 0.5082 0.4986 0.3978 0.1423 0.3351 0.4001 0.6971 0.2674 0.2182 0.685 0.6432 0.6226 0.7084 0.6228 0.7452; 0.4904 0.5168 0.9814 0.9485 0.9344 0.9239 0.9094 0.907 1.0989 0.9581 0.8439 0.5094 0.4607 0.4581 0.438 0.4064 0.9969 0.9937 0.9482 0.9061 0.8957 0.7843 0.7513 0.7061 0.6971 1.0753 1.0703 1.0693 1.0605 0.126 0.139 0.0947 0.1359 0.1427 0.4411 0.5693 0.604 0.62245 0.7027 0.7077 0.3983 0.3189 0.3063 1.0409 0.9443 0.9075 0.6632 0.6004 0.4992 0.7729 0.7751 0.78 0.7907 0.7992 0.8234 0.87695 0.8907 0.9263 0.9593 0.7807 0.8221 1.0037 0.3333 0.328 0.3149 1.0586 0.8413 0.7914 0.7392 0.8981 0.7818 0.7703 0.7551 0.7223 0.4622 0.4731 0.577 0.4283 0.4861 0.5735 0.7424 0.741 0.7355 0.7322 0.7214 0.7624 0.9219 0.83545 0.8342 0.7718 0.7041 0.7098 0.7733 0.9528 0.2515 0.2782 0.2841 0.40015 0.4117 0.4586 0.1956 0.2002 0.222 0.2312 0.7575 0.8673 0.3942 0.3897 0.3778 0.3638 0.3471 0.3352 0.2386 0.1788 0.0674 0.8776 0.7764 0.969 0.7684 0.7276 0.8568 0.921 0.9272 0.94 0.4834 0.6226 0.6426 0.6456 0.2169 0.154 0.0345 0.2752 0.1923 0.1906 0.183 0.1816 0.1459 0.1426 0.1651 0.1592 0.1333 0.1297 0.5157 0.4583 0.3529 0.4549 0.4957 0.2896 0.2918 0.3629 0.4282 0.5192 0.7772 0.7094 0.9229 0.8917 0.8389 0.8167 0.0061 0.07755 0.20555 0.2391 0.3048 0.0 0.9417 0.9705 0.9966 1.0545 0.6364 0.8568 0.4165 0.4388 0.4481 0.4713 0.2841 0.379 0.4312 0.4493 0.3815 0.3698 0.3169 0.3048 0.3036 0.2015 0.3637 0.3353 0.2863 0.17805 0.17595 0.17035 0.0459 0.4395 0.3708 0.3428 0.3281 0.2774 0.5455 0.6184 0.0357 0.3895 0.8019 0.7491 0.7296 0.7117 0.0774 0.1127 0.1404 0.2034 0.2004 0.1761 0.1098 0.3943 0.322 0.2742 0.1159 1.0629 1.0605 1.0575 0.2903 0.2855 0.1907 0.6278 0.6221 0.4932 0.366 0.5464 0.4516 0.1362 0.2323 0.406 0.4165 0.6226 0.7119 0.8832 0.8972 0.9118 1.00515 1.01 0.3652 0.2815 0.2447 0.1504 0.5897 0.6359 1.0997 0.2456 0.25 0.3092 0.4978 0.477 0.6228 0.622 0.3856 0.2593 0.1954 0.3299 0.4201 0.4269 1.0199 0.9191 0.8937 0.6741 0.7285 0.7296 0.7311 0.661 0.5967 0.5312 0.869 0.9032 0.9558 0.7758 0.7743 0.764 0.2396 0.45575 0.5878 0.3142 0.1172 0.8137 0.7443 0.2341 0.3234 0.3378 0.3399 1.0191 0.8927 0.1943 0.0961 0.7605 0.6513 0.3507 0.3443 0.3311 0.902 0.604 0.7244 0.9202 1.0818 0.7086 0.698 0.7478 1.0476 0.1394 0.1863 0.3782 0.6345 0.5357 1.0131 0.9593 0.8888 0.9262 0.3152 0.4392 0.8675 1.1366 1.0586 0.7229 0.5083 0.0418 0.196 0.4482 0.4784 0.7245 0.6409 0.2299 0.1181 0.4672 0.4508], Array{Int64,1}[[1, 2], [3, 4], [4, 5], [4, 18], [4, 260], [5, 6], [5, 19], [5, 236], [6, 7], [6, 19], [6, 20], [7, 8], [7, 20], [7, 298], [9, 10], [10, 11], [10, 61], [10, 62], [12, 13], [13, 14], [13, 100], [14, 15], [14, 100], [14, 329], [15, 16], [15, 257], [15, 314], [17, 18], [18, 19], [18, 167], [19, 166], [20, 21], [20, 270], [21, 22], [21, 269], [21, 270], [22, 23], [22, 105], [22, 106], [23, 24], [23, 82], [23, 86], [24, 25], [24, 39], [24, 300], [26, 27], [27, 28], [27, 123], [27, 299], [28, 29], [28, 237], [28, 245], [30, 31], [32, 33], [33, 34], [33, 130], [33, 131], [35, 36], [36, 37], [36, 177], [36, 232], [37, 38], [37, 125], [37, 126], [38, 39], [38, 126], [38, 223], [39, 40], [39, 301], [41, 42], [42, 43], [42, 149], [42, 150], [44, 45], [45, 46], [45, 57], [45, 66], [47, 48], [48, 49], [48, 243], [48, 244], [50, 51], [51, 52], [51, 272], [51, 273], [52, 53], [52, 88], [52, 273], [53, 54], [53, 89], [53, 90], [54, 55], [54, 71], [54, 89], [55, 56], [55, 70], [55, 71], [56, 57], [56, 217], [56, 315], [57, 58], [57, 67], [58, 59], [58, 67], [58, 303], [60, 61], [61, 93], [61, 94], [63, 64], [64, 65], [64, 180], [64, 220], [67, 68], [67, 302], [68, 69], [68, 169], [68, 170], [71, 72], [71, 119], [72, 73], [72, 90], [72, 119], [73, 74], [73, 90], [73, 91], [75, 76], [76, 77], [76, 226], [76, 227], [78, 79], [79, 80], [79, 146], [79, 147], [81, 82], [82, 83], [82, 85], [83, 84], [83, 297], [83, 298], [87, 88], [88, 89], [88, 118], [88, 295], [90, 273], [92, 93], [93, 280], [93, 281], [95, 96], [96, 97], [96, 134], [96, 187], [97, 98], [97, 187], [97, 247], [98, 99], [98, 194], [98, 257], [99, 100], [99, 193], [99, 257], [100, 328], [101, 102], [102, 103], [102, 254], [102, 255], [103, 104], [103, 137], [103, 214], [107, 108], [108, 109], [108, 150], [108, 151], [109, 110], [109, 212], [109, 213], [110, 111], [110, 176], [110, 240], [111, 112], [111, 175], [111, 176], [113, 114], [114, 115], [114, 141], [114, 163], [116, 117], [119, 120], [119, 274], [121, 122], [122, 123], [122, 298], [122, 312], [123, 124], [123, 298], [126, 127], [126, 232], [127, 128], [127, 232], [127, 233], [129, 130], [130, 140], [130, 141], [132, 133], [133, 134], [133, 188], [133, 326], [134, 135], [134, 188], [135, 136], [135, 188], [135, 305], [136, 137], [136, 190], [136, 305], [137, 138], [137, 215], [139, 140], [140, 241], [140, 242], [141, 142], [141, 164], [143, 144], [144, 145], [144, 173], [144, 174], [148, 149], [149, 214], [149, 283], [150, 213], [150, 239], [151, 152], [151, 176], [151, 177], [153, 154], [155, 156], [156, 157], [156, 261], [156, 311], [157, 158], [157, 261], [157, 262], [159, 160], [160, 161], [160, 182], [160, 199], [161, 162], [161, 183], [161, 184], [165, 166], [166, 167], [166, 237], [167, 168], [167, 259], [171, 172], [172, 173], [172, 181], [172, 276], [173, 183], [173, 197], [176, 253], [177, 178], [177, 231], [179, 180], [180, 181], [180, 230], [181, 182], [181, 275], [182, 183], [182, 200], [183, 196], [185, 186], [186, 187], [186, 194], [186, 313], [187, 248], [188, 189], [188, 206], [189, 190], [190, 191], [190, 304], [190, 327], [192, 193], [193, 194], [193, 256], [194, 195], [197, 198], [197, 267], [197, 268], [201, 202], [202, 203], [202, 264], [202, 290], [203, 204], [203, 264], [203, 265], [205, 206], [206, 207], [206, 320], [207, 208], [207, 229], [207, 279], [209, 210], [210, 211], [210, 288], [210, 289], [213, 214], [213, 240], [214, 254], [216, 217], [217, 218], [219, 220], [220, 221], [220, 229], [222, 223], [223, 224], [223, 252], [224, 225], [224, 249], [224, 250], [228, 229], [229, 278], [232, 251], [234, 235], [235, 236], [235, 261], [235, 270], [236, 260], [236, 270], [237, 238], [240, 241], [240, 254], [241, 254], [241, 282], [246, 247], [247, 283], [247, 305], [257, 258], [260, 261], [260, 271], [263, 264], [264, 291], [266, 267], [267, 318], [267, 319], [273, 296], [276, 277], [276, 322], [276, 323], [283, 284], [283, 293], [284, 285], [284, 293], [284, 294], [286, 287], [292, 293], [293, 306], [305, 321], [307, 308], [309, 310], [316, 317], [324, 325]])

model = V,EV
V,EVs = Lar.biconnectedComponent(model)
EW = convert(Lar.Cells, cat(EVs))
VV = [[k] for k=1:size(V,2)]

hpc = Plasm.lar2hpc(V,EW)
cyan = Plasm.color("cyan")
out = cyan(hpc)
Plasm.view( out )

colors = ["orange", "red", "green", "blue", "cyan", "magenta", "yellow", 
"white", "black", "purple", "gray", "brown"]

hpccolors = [Plasm.color(key) for key in colors]
comps = [Plasm.lar2hpc(V,EV) for EV in EVs]::Array{Plasm.Hpc,1}

using PyCall
p = PyCall.pyimport("pyplasm")

Plasm.view(p.STRUCT([hpccolors[k](comps[k]) for k=1:length(comps)]))

