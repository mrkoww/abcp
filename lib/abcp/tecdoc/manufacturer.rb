module Abcp
  class Manufacturer < Struct.new(:id, :name)

    def self.parse_manufacturers(data)
      result = {}
      data.each_with_index do |manufacturer, index|
        result[manufacturer["name"]] = Manufacturer.new(manufacturer["id"], manufacturer["name"])
      end
      result
    end

  end
end
