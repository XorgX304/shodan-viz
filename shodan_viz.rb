class ShodanViz < Sinatra::Base
  # get yaml config
  register Sinatra::ConfigFile
  config_file 'config/initializers.yml'
  # init shodan api
  shodan_api = Shodan::Shodan.new(settings.api_key)

  get '/' do
    slim :index
  end

  get '/search/:query' do
    # Todo: parse query to determine whether to use host or query endpoint

    begin
      my_ip = `curl http://ipecho.net/plain` #get current external IP
      shodan_result = shodan_api.search params['query'], facets: 'country:25,org:15,os:5'
    rescue Exception => e
      # handle no results or timeouts
      puts "Error: #{e.to_s}"
      shodan_result = {
        'error': e.to_s
      }
    end

    content_type :json
    shodan_result.to_json
  end



end
