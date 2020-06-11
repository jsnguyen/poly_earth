function get_unit_plane_normal(A::Array{Float64,1},B::Array{Float64,1},C::Array{Float64,1})

  AB = B-A
  AC = C-A

  plane_normal = cross(AB,AC)
  unit_plane_normal = normalize(plane_normal)

  for el in unit_plane_normal
    if isnan(el)
      println("Found NaN! ",A,B,C)
    end
  end

  return unit_plane_normal
end

function write_stl_ascii(filename::String,triangles::Array{Array{Array{Float64,1},1},1})
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

    end

    write(f,"endsolid mesh\n")

  end

end

function write_stl_binary(filename::String,triangles::Array{Array{Array{Float64,1},1},1})
  open(filename,"w") do f 

    write(f,zeros(UInt8,80))
    write(f,convert(UInt32,size(triangles,1)))
    for (i,tri) in enumerate(triangles)

      norm = get_unit_plane_normal(tri...)
      write(f,convert(Float32,norm[1]))
      write(f,convert(Float32,norm[2]))
      write(f,convert(Float32,norm[3]))

      for vertex in tri
        write(f,convert(Float32,vertex[1]))
        write(f,convert(Float32,vertex[2]))
        write(f,convert(Float32,vertex[3]))
      end

      write(f,convert(UInt16,0))

    end

  end

end
