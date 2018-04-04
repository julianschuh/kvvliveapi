module KVVLiveAPI
  # Instances of this class represent the depature
  # of a vehicle of a specific route with a
  # specified destination at a specified time.
  #
  # It contins additional information about the
  # depature and vehicle.
  class Departure
    class << self
      def from_json(json)
        new(json['route'],
            json['destination'],
            json['direction'],
            json['time'],
            json['lowfloor'],
            json['realtime'],
            json['traction'],
            json['stopPosition'])
      end
    end

    # The route for which the depature is valid, e.g. 2 or S7
    attr_reader :route

    # Final destination of the vehicle
    attr_reader :destination

    # Number representing the direction
    attr_reader :direction

    # Indicates the accessibility of the used vehicle
    attr_reader :lowfloor

    # Indicates if the depature is a realtime estimation
    attr_reader :realtime

    # Specified if single or double traction is used
    attr_reader :traction

    # Depature time
    attr_reader :time

    # Number representing the "sub-stop", as in some cases
    # a single stops might have different sub-stops for
    # different kinds if vehicles
    attr_reader :stop_position

    def initialize(route, destination, direction, time, lowfloor, realtime, traction, stop_position)
      @route = route
      @destination = destination
      @direction = direction
      @lowfloor = lowfloor
      @realtime = realtime
      @traction = traction
      @time = convert_timestr(time)
      @stop_position = stop_position
    end

    def to_s
      @route + ' (-> ' + @destination + ') @ ' + @time.getlocal.strftime('%H:%M') + ', Stop ' + @stop_position.to_s
    end

    private

    def convert_timestr(time)
      timestr = time.to_s
      now = Time.now.getlocal

      return now.getutc if timestr == 'sofort' || timestr == '0'

      if (mtch = /^([1-9]) min$/.match(timestr))
        return now.advance(minutes: mtch[1].to_i).getutc
      end

      if (mtch = /^([0-2]?[0-9]):([0-5][0-9])$/.match(timestr))
        resulting_time = now.change(hour: mtch[1].to_i, min: mtch[2].to_i)
        resulting_time += 1.day if resulting_time < now
        return resulting_time.getutc
      end

      nil
    end
  end
end