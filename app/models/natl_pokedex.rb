require 'pokeapi'

class NatlPokedex < PokeApi

  attr_reader :pokemon

  def initialize
    resource = '/api/v1/pokedex/1/'
    @data = json_hash(resource)

    set_pokemon
    set_ids
    @pokemon.sort_by! { |p| p['id'] }
  end

  def size
    @pokemon.size
  end

  private

    def set_pokemon
      @pokemon = @data['pokemon']
      @pokemon.select! do |hash|
        id(hash) <= 718
      end

      @pokemon.map { |p| p['name'].capitalize! }
    end

    def set_ids
      @pokemon.map { |hash| hash['id'] = id(hash) }
    end

    def id(hash)
      uri = hash['resource_uri']
      uri[/pokemon\/(.*)\//, 1].to_i
    end
end