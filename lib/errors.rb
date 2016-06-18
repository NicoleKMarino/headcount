class UnknownDataError < StandardError
  def message
    "Unknown Data Error"
  end
end

class UnknownRaceError < StandardError
end
