require 'test_helper'

class PokemonTest < Minitest::Test

   def stub_bulbasaur
    pokemon = File.open("test/fixtures/json/pokemon_1.json")

    stub_request(:get, "http://pokeapi.co/api/v1/pokemon/1/").with(
      headers: {
        'Accept' => '*/*', 
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 
        'User-Agent' => 'Ruby'
      }).to_return(status: 200, body: pokemon, headers: {})

    description = File.open("test/fixtures/json/description_15.json")
    stub_request(:get, "http://pokeapi.co/api/v1/description/15/").with(
      headers: {
        'Accept' => '*/*', 
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 
        'User-Agent' => 'Ruby'
      }).to_return(status: 200, body: description, headers: {})
  end

  def stub_lucario
    pokemon = File.open("test/fixtures/json/pokemon_448.json")

    stub_request(:get, "http://pokeapi.co/api/v1/pokemon/448/").with(
      headers: {
        'Accept' => '*/*', 
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 
        'User-Agent' => 'Ruby'
      }).to_return(status: 200, body: pokemon, headers: {})

    description = File.open("test/fixtures/json/description_5583.json")
    stub_request(:get, "http://pokeapi.co/api/v1/description/5583/").with(
      headers: {
        'Accept' => '*/*', 
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 
        'User-Agent' => 'Ruby'
      }).to_return(status: 200, body: description, headers: {})
  end

  def test_can_get_bulbasaur
    id = 1
    stub_bulbasaur

    bulbasaur = Pokemon.new(id)
    refute_nil bulbasaur
    assert_equal bulbasaur.name, "Bulbasaur"
    assert_equal bulbasaur.national_id, 1
    assert_equal bulbasaur.weight, 6.9
    assert_equal bulbasaur.height, 0.7
    assert_match /it grows by gaining nourishment/, bulbasaur.description
    assert_equal bulbasaur.types, ["Grass", "Poison"].sort
    assert_equal bulbasaur.abilities, ["Chlorophyll", "Overgrow"].sort
    assert_equal bulbasaur.moves.first, "Amnesia"
    assert_equal bulbasaur.moves.last,  "Worry Seed"
  end

  def test_can_get_lucario
    id = 448
    stub_lucario

    lucario = Pokemon.new(id)
    refute_nil lucario
    assert_equal lucario.name, "Lucario"
    assert_equal lucario.national_id, 448
    assert_equal lucario.weight, 54.0
    assert_equal lucario.height, 1.2
    assert_match /read their thoughts and movements/, lucario.description
    assert_equal lucario.types, ["Fighting", "Steel"].sort
    assert_equal lucario.abilities, ["Inner Focus", "Justified", "Steadfast"].sort
    assert_equal lucario.moves.first, "Attract"
    assert_equal lucario.moves.last,  "Zen Headbutt"
  end
end