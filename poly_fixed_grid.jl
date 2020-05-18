using LinearAlgebra
include("./hgt_parse.jl")

function get_unit_plane_normal(A::Array{Float64,1},B::Array{Float64,1},C::Array{Float64,1})

  AB = B-A
  AC = C-A

  plane_normal = cross(AB,AC)
  unit_plane_normal = normalize(plane_normal)
  return unit_plane_normal
end

function get_triangles(filename,grid_size::Int64)
  n_triangles = 2*(grid_size-1)*(grid_size-1)
  triangles = Array{Array{Float64}}(undef,n_triangles)

  data = parse_hgt(filename)

  tri_counter=1
  for i in 1:grid_size-1
    for j in 1:grid_size-1
      #=
      triangle_a = [i   j   0;
                    i+1 j   0;
                    i   j+1 0]
      triangle_b = [i+1   j+1   0;
                    i+1-1 j+1   0;
                    i+1   j+1-1 0]
      =#
      
      triangle_a = Array{Array{Float64}}(undef,3)
      
      lat,lon = index_to_coords(filename,i,j)
      triangle_a[1] = [lat lon data[i][j]]
      lat,lon = index_to_coords(filename,i+1,j)
      triangle_a[2] = [lat lon data[i+1][j]]
      
      lat,lon = index_to_coords(filename,i,j+1)
      triangle_a[3] = [lat lon data[i][j+1]]

      lat,lon = index_to_coords(filename,i+1,j+1)
      triangle_b[1] = [lat lon data[i+1][j+1]]
      lat,lon = index_to_coords(filename,i+1-1,j+1)
      triangle_b[2] = [lat lon data[i+1-1][j+1]]
      lat,lon = index_to_coords(filename,i+1,j+1-1)
      triangle_b[3] = [lat lon data[i+1][j+1-1]]

      triangles[tri_counter] = triangle_a
      tri_counter+=1
      triangles[tri_counter] = triangle_b
      tri_counter+=1

    end
  end
  return triangles

end

filename = "n37w122.hgt"
data = parse_hgt(filename)
lat,lon = index_to_coords(filename,2,2)
println(get_triangles(filename,3601))

#println(get_unit_plane_normal([1.0,1.0,1.0],[2.0,2.0,0.0],[3.0,0.0,3.0]))
