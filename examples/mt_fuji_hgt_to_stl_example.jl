include("../src/triangles_hgt.jl")
include("../src/parse_hgt.jl")
include("../src/slicing.jl")
include("../src/stl_format.jl")

center = [35.362729, 138.730627] # Mt. Fuji
box_size = 300 # size in integer arcsec
coords = center_bounds_coords(center,box_size,box_size)
filename = get_filename_from_coords(center,"../hgt_data/")
data = parse_hgt(filename)
println(filename)

sliced_data = slice_data(data,coords)

offset=convert(Float64,minimum(sliced_data)) - 10  # NaN occurs if offset equals the minimum value

mesh_triangles = get_mesh_triangles(sliced_data)
side_triangles = get_side_triangles(sliced_data,offset)
base_triangles = get_base_triangles(sliced_data,offset)

triangles = cat(base_triangles,cat(mesh_triangles,side_triangles,dims=1),dims=1)

println("Writing triangles to file...")
write_stl_binary("out.stl",triangles)
println("Done writing triangles to file...")
