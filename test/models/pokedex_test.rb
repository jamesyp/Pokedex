require 'test_helper'

class PokedexTest < Minitest::Test

  def setup
    pokedex = File.open("test/fixtures/json/pokedex_1.json")

    stub_request(:get, "http://pokeapi.co/api/v1/pokedex/1/").with(
      headers: {
        'Accept' => '*/*', 
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 
        'User-Agent' => 'Ruby'
      }).to_return(status: 200, body: pokedex, headers: {})
  end

  def test_can_get_national_pokedex

    pokedex = NatlPokedex.new
    refute_nil pokedex
    refute_nil pokedex.pokemon

    assert_equal pokedex.size, 718

    assert_equal pokedex.pokemon.first['id'], 1
    assert_equal pokedex.pokemon.first['name'], "Bulbasaur"

    assert_equal pokedex.pokemon.last['id'], 718
    assert_equal pokedex.pokemon.last['name'], "Zygarde"
  end
end