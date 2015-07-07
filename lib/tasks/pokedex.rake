namespace :pokedex do
  desc "Download all Pokemon images from Bulbapedia -- Bulbasaur through Zygarde"
  # Images will be stored in app/assets/images/pokemon/xxx_name.png
  task scrape_pokemon_images: :environment do
    require 'bulbapedia'
    Bulbapedia.scrape_images
  end

end
