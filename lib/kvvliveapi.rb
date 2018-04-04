require 'faraday'
require 'json'
require 'uri'
require 'cgi'

require 'active_support/all'

require 'kvvliveapi/version'
require 'kvvliveapi/constants'
require 'kvvliveapi/stop'
require 'kvvliveapi/depature'

# Main module for accessing the KVV live API.
# All API functions can be called directly on the class object.
module KVVLiveAPI
  class << self

    # Retrieves a list of stops whose names match a given string
    #
    # * +name+ - name or fragment of the name of the Stop that is searched
    def stops_by_name(name)
      stops('stops/byname/' + CGI.escape(name))
    end

    # Retrieves a list of stops close to a given set of coordinates
    #
    # * +lat+ - latitude
    # * +long+ - longitude
    def stops_by_coordinates(lat, lon)
      stops('stops/bylatlon/' + ('%.6f' % lat) + '/' + ('%.6f' % lon))
    end

    # Retrieves a single stop object by its ID
    #
    # * +stop_id+ - ID of the Stop to retrieve
    def stops_by_id(stop_id)
      [Stop.from_json(query('stops/bystop/' + CGI.escape(stop_id)))]
    end

    # Retrieves a list of upcoming depatures for a specified Stop ID
    #
    # * +stop_id+ - ID of the Stop for which upcoming depatures should
    # be retrieved
    def depatures_by_stop(stop_id)
      departures('departures/bystop/' + stop_id)
    end

    # Retrieves a list of upcoming depatures for a specified rouute
    # at a specified Stop ID
    #
    # * +route+ - Route for which upcoming depatures should be retrieved
    # * +stop_id+ - ID of the Stop for which upcoming depatures should
    #   be retrieved
    def depatures_by_route(route, stop_id)
      departures('departures/byroute/' + CGI.escape(route) + '/' + CGI.escape(stop_id))
    end

    private

    def stops(api_path)
      query(api_path)['stops'].map do |stop|
        Stop.from_json(stop)
      end
    end

    def departures(api_path)
      query(api_path)['departures'].map do |stop|
        Departure.from_json(stop)
      end
    end

    def query(path, params = {})
      params.merge!({ key: API_KEY })

      uri = URI.parse(API_BASE + path).tap do |u|
        u.query = URI.encode_www_form(params)
      end

      response = Faraday.get(uri)
      JSON.parse!(response.body)
    end
  end
end
