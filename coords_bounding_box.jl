include("./hgt_parse.jl")
include("./poly_fixed_grid.jl")
include("./stl_format.jl")
include("./geo_coords_bounds.jl")

center = [37.880516, -121.913578]
box_size = 100 # size in integer arcsec
coords = bounding_box_coords(center,box_size)
println(coords)

filename = "n37w121.hgt"
data = parse_hgt(filename)
sliced_data = slice_data(data,coords)

mesh_triangles = get_mesh_triangles(sliced_data,100)

triangles = mesh_triangles

println("Writing triangles to file...")
write_triangle("out.stl",triangles)
println("Done writing triangles to file...")
