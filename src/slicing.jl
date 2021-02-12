# input in deg
function get_arcsec_index(coord::Float64)
  # indicies start at 1! so +1
  # 3600 arcsec/deg
  return (1+(round(Int,coord*3600.0) % 3600))
end

function center_bounds_coords(center::Array{Float64,1},box_size_lat::Int64,box_size_lon::Int64)
  coords = [center[1]-box_size_lat/2.0/3600.0,center[1]+box_size_lat/2.0/3600.0,center[2]-box_size_lon/2.0/3600.0,center[2]+box_size_lon/2.0/3600.0]
  return coords
end

function get_slice_indicies_corner(coords::Array{Float64,1})
  lat_span = round(Int,abs(coords[2]-coords[1])*3600)
  lon_span = round(Int,abs(coords[4]-coords[3])*3600)

  bottom_left_lat = get_arcsec_index(abs(coords[1]))
  bottom_left_lon = get_arcsec_index(abs(coords[3]))

  if coords[1] < 0 && coords[2] < 0
    bottom_left_lat = 3601-get_arcsec_index(abs(coords[1]))
  else
    bottom_left_lat = get_arcsec_index(coords[1])
  end

  if coords[3] < 0 && coords[4] < 0
    bottom_left_lon = 3601-get_arcsec_index(abs(coords[3]))
  else
    bottom_left_lon = get_arcsec_index(coords[3])
  end

  return [bottom_left_lat,bottom_left_lat+lat_span,bottom_left_lon,bottom_left_lon+lon_span]
end

function slice_data(data::Array{Int16,2},coords::Array{Float64,1})
  indicies = get_slice_indicies_corner(coords)
  println("Slice indicies ",indicies)
  return data[indicies[1]:indicies[2],indicies[3]:indicies[4]]
end

function get_tile_filenames_from_coords(coords::Array{Float64,1}, data_dir::String)
      
    trunc_coords = Array{Int64,1}(undef,4)
    for (i,coo) in enumerate(coords)
        trunc_coords[i] = trunc(Int,coords[1])
    end
    
    n_lat_tiles = abs(trunc(Int,coords[1])-trunc(Int,coords[2]))+1
    n_lon_tiles = abs(trunc(Int,coords[3])-trunc(Int,coords[4]))+1

    filenames = Array{String,1}(undef,0)
    tiles = Array{Array{Int16,2},2}(undef,n_lat_tiles,n_lon_tiles)
    for i in 1:n_lat_tiles
        lat = trunc(coords[1])+i-1
        for j in 1:n_lon_tiles
            lon = trunc(coords[3])+j-1
            fn = get_filename_from_coords([Float64(lat),Float64(lon)], data_dir)
            data = parse_hgt(fn)
            tiles[i,j] = data
            append!(filenames,[fn])
        end
    end  
    
    return tiles,filenames
end

# lat,lon
function get_filename_from_coords(center::Array{Float64,1}, data_dir::String)
    filename = ""
    
    lat_int = trunc(Int,abs(center[1]))
    lon_int = trunc(Int,abs(center[2]))
    
    if center[1] < 0
        lat_char = "s"
        lat_int = lat_int+1
    else
        lat_char = "n"
    end
        
    if center[2] < 0
        lon_char = "w"
        lon_int = lon_int+1
    else
        lon_char = "e"
    end
     
    lat_str = string(lat_int)
    lon_str = string(lon_int)

    
    padding = ""
    if lon_int<100
        padding="0"
    end

    filename = string(data_dir,lat_char,lat_str,lon_char,padding,lon_str,".hgt")
    return filename
end

function index_to_coords(filename::String,i::Int64,j::Int64)
  # indicies start at 1
  @assert 1 <= i <= HGT_SQ_SZ
  @assert 1 <= j <= HGT_SQ_SZ 
  
  revised = filename[1:end-length(".hgt")]
  ud = ['n','s']
  lr = ['e','w']


  UD = '0'
  LR = '0'

  for char in ud
    if occursin(char,revised)
      UD = char
      break
    end
  end

  for char in lr
    if occursin(char,revised)
      LR = char
      break
    end
  end

  second_index = 0
  for char in [UD,LR]
    res = findfirst(isequal(char),revised)
    if res == nothing || res == 1
      continue
    else
      second_index = res
    end
  end

  lat = parse(Float64,revised[2:second_index-1])
  lon = parse(Float64,revised[second_index+1:end])

  lat_inc = (i-1)*arcsec2deg
  lon_inc = (j-1)*arcsec2deg

  if UD == 's'
    lat = -lat
    lat -= lat_inc
  else
    lat += lat_inc
  end

  if LR == 'w'
    lon = -lon
    lon -= lon_inc 
  else
    lon += lon_inc 
  end


  return lat,lon
end
