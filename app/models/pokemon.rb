require 'pokeapi'

class Pokemon < PokeApi

  attr_reader :name
  attr_reader :national_id
  attr_reader :height
  attr_reader :weight
  attr_reader :description
  attr_reader :types
  attr_reader :abilities
  attr_reader :moves

  attr_reader :data

  def initialize(id)
    resource = "/api/v1/pokemon/#{id}/"
    @data = json_hash(resource)

    @name        = @data['name']
    @national_id = @data['national_id']
    @height      = @data['height'].to_i / 10.0
    @weight      = @data['weight'].to_i / 10.0

    set_description
    set_types
    set_abilities
    set_moves
  end

  private

    def set_description
      descriptions = @data['descriptions']
      latest_description = descriptions.max_by do |desc|
        desc['name']
      end
      
      uri = latest_description['resource_uri']
      desc_hash = json_hash(uri)
      @description = desc_hash['description']
    end

    def set_types
      @types = extract_names(@data['types']).sort
    end

    def set_abilities
      @abilities = extract_names(@data['abilities']).sort
      translate_format @abilities
    end

    def set_moves
      @moves = extract_names(@data['moves']).sort
      translate_format @moves
    end

    def extract_names(hash)
      hash.map { |e| e['name'].capitalize }
    end

    def translate_format(array)
      array.map! do |str|
        str.sub('-', ' ').split.map(&:capitalize).join(' ')
      end
    end
end