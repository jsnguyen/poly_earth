function get_unit_plane_normal(A::Array{Float64,1},B::Array{Float64,1},C::Array{Float64,1})

  AB = B-A
  AC = C-A

  plane_normal = cross(AB,AC)
  unit_plane_normal = normalize(plane_normal)
  return unit_plane_normal
end

function write_triangle(filename::String,triangles::Array{Array{Array{Float64,1},1},1})
  open(filename,"w") do f 

    write(f,"solid mesh\n")
    for (i,tri) in enumerate(triangles)

      norm = get_unit_plane_normal(tri...)
      str = @sprintf "facet normal %e %e %e\n" norm[1] norm[2] norm[3]
      write(f,str)
      write(f,"outer loop\n")

      for vertex in tri
        str = @sprintf "vertex %e %e %e\n" vertex[1] vertex[2] vertex[3]
        write(f,str)
      end

      write(f,"endloop\n")
      write(f,"endfacet\n")

      @printf("%3.2f%%\n",100.0*(i/length(triangles)))

    end

    write(f,"endsolid mesh\n")

  end

end
