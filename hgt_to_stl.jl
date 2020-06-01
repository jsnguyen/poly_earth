include("./hgt_parse.jl")
include("./poly_fixed_grid.jl")
include("./stl_format.jl")

filename = "n37w122.hgt"
data = parse_hgt(filename)

println("Getting triangles...")
triangles = get_triangles(filename,40)
println("Done getting triangles...")

println("Writing triangles to file...")
write_triangle("out.stl",triangles)
println("Done writing triangles to file...")
