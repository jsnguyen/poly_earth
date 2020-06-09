const HGT_SQ_SZ = 3601
const arcsec2deg = 1/3600

function parse_hgt(filename::String)
  raw_data = Array{UInt8}(undef, HGT_SQ_SZ*HGT_SQ_SZ)

  open(filename,"r") do file
    readbytes!(file,raw_data,Inf)
  end

  data = reinterpret(Int16, raw_data)
  data = (ntoh).(data)

  new_data = reverse(transpose(reshape(data,HGT_SQ_SZ,HGT_SQ_SZ)),dims=1)
  
  return new_data
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

#=
filename = "n37w122.hgt"
new_data = parse_hgt(filename)
lat,lon = index_to_coords(filename,2,2)
println(lat,",",lon)
print(new_data[1,2])
=#
