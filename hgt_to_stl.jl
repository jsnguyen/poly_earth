include("./hgt_parse.jl")
include("./poly_fixed_grid.jl")
include("./stl_format.jl")

filename = "n37w122.hgt"
data = parse_hgt(filename)

mesh_size = 100
offset=0.0
println("Getting triangles...")
mesh_triangles = get_mesh_triangles(filename,mesh_size)
side_triangles = get_side_triangles(filename,mesh_size,offset)
base_triangles = get_base_triangles(mesh_size,offset)
println("Done getting triangles...")

triangles = cat(base_triangles,cat(mesh_triangles,side_triangles,dims=1),dims=1)

println("Writing triangles to file...")
write_triangle("out.stl",triangles)
println("Done writing triangles to file...")
