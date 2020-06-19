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

