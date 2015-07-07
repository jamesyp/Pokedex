require 'open-uri'
require 'json'

# Gets pokemon information from pokeapi.co json api
class Pokemon
  attr_reader :name
  attr_reader :national_id
  attr_reader :types

  attr_reader :data

  def initialize(id)
    resource = 'pokemon/' + id.to_s
    @data = json_hash(resource)

    @name        = @data['name']
    @national_id = @data['national_id']
  end

  private

    def json_hash(resource)
      uri = "http://pokeapi.co/api/v1/#{resource}"
      JSON.parse(open(uri).read)
    end
end