using LinearAlgebra
using Printf

function get_triangles_real_coords(filename::String,grid_size::Int64)
  n_triangles = 2*(grid_size-1)*(grid_size-1)
  triangles = Array{Array{Array{Float64,1},1},1}(undef,n_triangles)

  data = parse_hgt(filename)

  tri_counter=1
  triangle_a = Array{Array{Float64,1},1}(undef,3)
  triangle_b = Array{Array{Float64,1},1}(undef,3)

  for i in 1:3
    triangle_a[i] = Array{Float64,1}(undef,3)
    triangle_b[i] = Array{Float64,1}(undef,3)
  end

  for i in 1:grid_size-1
    for j in 1:grid_size-1
      
      lat,lon = index_to_coords(filename,i,j)
      triangle_a[1][1] = lat
      triangle_a[1][2] = lon
      triangle_a[1][3] = data[i,j]

      lat,lon = index_to_coords(filename,i+1,j)
      triangle_a[2][1] = lat
      triangle_a[2][2] = lon
      triangle_a[2][3] = data[i+1,j]

      lat,lon = index_to_coords(filename,i,j+1)
      triangle_a[3][1] = lat
      triangle_a[3][2] = lon
      triangle_a[3][3] = data[i,j+1]

      lat,lon = index_to_coords(filename,i+1,j+1)
      triangle_b[1][1] = lat
      triangle_b[1][2] = lon
      triangle_b[1][3] = data[i+1,j+1]

      lat,lon = index_to_coords(filename,i+1-1,j+1)
      triangle_b[2][1] = lat
      triangle_b[2][2] = lon
      triangle_b[2][3] = data[i+1-1,j+1]

      lat,lon = index_to_coords(filename,i+1,j+1-1)
      triangle_b[3][1] = lat
      triangle_b[3][2] = lon
      triangle_b[3][3] = data[i+1,j+1-1]

      triangles[tri_counter] = triangle_a
      tri_counter+=1
      triangles[tri_counter] = triangle_b
      tri_counter+=1

    end
    @printf("%3.2f%%\n",100.0*(n_triangles\tri_counter))
  end

  return triangles
end

function get_triangles(filename::String,grid_size::Int64)
  n_triangles = 2*(grid_size-1)*(grid_size-1)
  triangles = Array{Array{Array{Float64,1},1},1}(undef,n_triangles)

  data = parse_hgt(filename)

  tri_counter=1
  triangle_a = Array{Array{Float64,1},1}(undef,3)
  triangle_b = Array{Array{Float64,1},1}(undef,3)

  for i in 1:3
    triangle_a[i] = Array{Float64,1}(undef,3)
    triangle_b[i] = Array{Float64,1}(undef,3)
  end

  for i in 1:grid_size-1
    for j in 1:grid_size-1
      
      triangle_a[1][1] = i
      triangle_a[1][2] = j
      triangle_a[1][3] = data[i,j]

      triangle_a[2][1] = i+1
      triangle_a[2][2] = j
      triangle_a[2][3] = data[i+1,j]

      triangle_a[3][1] = i 
      triangle_a[3][2] = j+1
      triangle_a[3][3] = data[i,j+1]

      triangle_b[1][1] = i+1
      triangle_b[1][2] = j+1 
      triangle_b[1][3] = data[i+1,j+1]

      triangle_b[2][1] = i
      triangle_b[2][2] = j+1
      triangle_b[2][3] = data[i,j+1]

      triangle_b[3][1] = i+1
      triangle_b[3][2] = j
      triangle_b[3][3] = data[i+1,j]

      triangles[tri_counter] = deepcopy(triangle_a)
      tri_counter+=1
      triangles[tri_counter] = deepcopy(triangle_b)
      tri_counter+=1

    end
    @printf("%3.2f%%\n",100.0*(n_triangles\tri_counter))
  end

  return triangles
end
