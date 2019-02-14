
const HGT_SQ_SZ = 3601
const arcsec2deg = 1/3600

function parse_hgt(filename)
  raw_data = Array{UInt8}(undef, HGT_SQ_SZ*HGT_SQ_SZ)

  open(filename,"r") do file
    readbytes!(file,raw_data,Inf)
  end

  data = reinterpret(Int16, raw_data)
  data = (ntoh).(data)
  data = reshape(data,HGT_SQ_SZ,HGT_SQ_SZ)

  return data
end

function index_to_coords(filename,i,j)
  # indicies start at 1
  
  revised = filename[1:end-length(".hgt")]
  println(revised)

  return (i-1)*arcsec2deg,(j-1)*arcsec2deg


end

filename = "n37w122.hgt"
data = parse_hgt(filename)
index_to_coords(filename,0,0)
