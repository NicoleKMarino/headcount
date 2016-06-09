class Opener
def initialize(file)
  @filename=file
  open_csv
end

def open_csv
   CSV.open(@filename, headers: true, header_converters: :symbol)
   retur
end

end
