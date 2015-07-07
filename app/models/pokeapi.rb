require 'open-uri'
require 'json'

# Gets pokemon information from pokeapi.co json api
class PokeApi

  private
    def json_hash(resource)
      uri = "http://pokeapi.co#{resource}"
      JSON.parse(open(uri).read)
    end
end