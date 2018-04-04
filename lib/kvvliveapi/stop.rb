module KVVLiveAPI
  # Instances of this class represent a stop operated
  # by the KVV
  class Stop
    class << self
      def from_json(json)
        new(json['name'], json['id'], json['lat'], json['lon'])
      end
    end

    # Name of the stop
    attr_reader :name

    # ID used to reference the stop
    attr_reader :stop_id

    # latitute of the location of the stop
    attr_reader :lat

    # longitude of the location of the stop
    attr_reader :lon

    def initialize(name, stop_id, lat, lon)
      @name = name
      @stop_id = stop_id
      @lat = lat
      @lon = lon
    end

    def to_s
      @name + '(' + @stop_id.to_s + ')'
    end
  end
end
