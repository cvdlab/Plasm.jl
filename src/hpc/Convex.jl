using QHull
#using Plasm, Revise

# ////////////////////////////////////////////////////////////////////////
function GLHull(points::Array{Float64,2})

	ch = QHull.chull(points)
	verts = ch.vertices
	vdict = Dict(zip(verts, 1:length(verts)))
	trias = [[vdict[u],vdict[v],vdict[w]] for (u,v,w) in ch.simplices]
	points = points[verts,:]

	faces = trias
	vertices=Vector{Float32}()
	normals =Vector{Float32}()
	for face in faces
		p3,p2,p1 = points[face[1],:],points[face[2],:],points[face[3],:]
		p1 = convert(Point3d, p1)
		p2 = convert(Point3d, p2)
		p3 = convert(Point3d, p3)
		n=0.5*computeNormal(p1::Point3d,p2::Point3d,p3::Point3d)

		append!(vertices,p1); append!(normals,n)
		append!(vertices,p2); append!(normals,n)
		append!(vertices,p3); append!(normals,n)
	end

	ret=GLMesh(GL_TRIANGLES)
	ret.vertices = GLVertexBuffer(vertices)
	ret.normals  = GLVertexBuffer(normals)
	return ret
end


points = rand(500,3)
VIEW([
      #GLCuboid(Box3d(Point3d(0,0,0),Point3d(1,1,1)))
      GLHull(points)
      GLAxis(Point3d(0,0,0),Point3d(1,1,1))
])
