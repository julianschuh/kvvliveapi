require 'net/http'
require 'json'
require 'uri'
require 'cgi'

require 'active_support/all'

API_KEY = '377d840e54b59adbe53608ba1aad70e8'.freeze
API_BASE = 'https://live.kvv.de/webapp/'.freeze

class Stop
  class << self
    def from_json(json)
      new(json['name'], json['id'], json['lat'], json['lon'])
    end
  end

  attr_reader :name
  attr_reader :stop_id
  attr_reader :lat
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

class Departure
  class << self
    def from_json(json)
      new(json["route"], json["destination"], json["direction"], json["time"], json["lowfloor"], json["realtime"], json["traction"], json["stopPosition"])
    end
  end

  attr_reader :route
  attr_reader :destination
  attr_reader :direction
  attr_reader :lowfloor
  attr_reader :realtime
  attr_reader :traction
  attr_reader :time
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
    @route + ' (-> ' + @destination + ') @ ' + @time.strftime('%H:%M') + ', Stop ' + @stop_position.to_s
  end

  private

  def convert_timestr(time)
    timestr = time.to_s
    now = Time.now

    return now if timestr == 'sofort' || timestr == '0'

    if (mtch = /^([1-9]) min$/.match(timestr))
      return now.advance(minutes: mtch[1].to_i)
    end

    if (mtch = /^([0-2]?[0-9]):([0-5][0-9])$/.match(timestr))
      resulting_time = now.change(hour: mtch[1].to_i, min: mtch[2].to_i)
      resulting_time += 1.day if resulting_time < now
      return resulting_time
    end

    nil
  end
end

class KVVAPI
  class << self
    protected :new

    def stops_by_name(name)
      stops('stops/byname/' + CGI::escape(name))
    end

    def stops_by_coordinates(lat, lon)
      stops('stops/bylatlon/' + ('%.6f' % lat) + '/' + ('%.6f' % lon))
    end

    def stops_by_id(stop_id)
      [Stop.from_json(query('stops/bystop/' + CGI::escape(stop_id)))]
    end

    def depatures_by_stop(stop_id)
      departures("departures/bystop/" + stop_id)
    end

    def depatures_by_route(route, stop_id)
      departures("departures/byroute/" + CGI::escape(route) + "/" + CGI::escape(stop_id))
    end

    private
    def stops(api_path)
      query(api_path)['stops'].map do |stop|
        Stop.from_json(stop)
      end
    end

    def departures(api_path, max_info=100)
      query(api_path)['departures'].map do |stop|
        Departure.from_json(stop)
      end
    end

    def query(path, params={})
      params.merge!({key: API_KEY})

      uri = URI.parse(API_BASE + path).tap do |u|
        u.query = URI.encode_www_form(params)
      end

      JSON.parse!(Net::HTTP.get_response(uri).body())
    end
  end
end
