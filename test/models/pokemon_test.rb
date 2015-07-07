require 'test_helper'

class PokemonTest < Minitest::Test

  def setup
    @id = 1

    stub_requests
  end

  def stub_requests
    json = File.open("test/fixtures/json/pokemon_1.json")

    stub_request(:get, "http://pokeapi.co/api/v1/pokemon/1").with(
      headers: {
        'Accept' => '*/*', 
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 
        'User-Agent' => 'Ruby'
      }).to_return(status: 200, body: json, headers: {})
  end

  def test_can_get_pokemon_from_id
    pokemon = Pokemon.new(@id)
    refute_nil pokemon
    assert_equal pokemon.name, "Bulbasaur"
    assert_equal pokemon.national_id, 1
  end
end