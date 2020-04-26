function parse_hgt(filename)
  size = 3601
  raw_data = Array{UInt8}(undef, size*size)
  open(filename,"r") do file
    readbytes!(file,raw_data,Inf)
  end

  data = reinterpret(Int16, raw_data)
  data .= ntoh.(data)
  data = reshape(data,3601,3601)

  return data
end

filename = "n37w122.hgt"
data = parse_hgt(filename)
println(data[3601,3601])
