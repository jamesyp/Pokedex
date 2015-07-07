require 'nokogiri'
require 'open-uri'
require 'pry'

module Bulbapedia
  BULBAPEDIA_BASE = "http://bulbapedia.bulbagarden.net"
  START_URL_SUFFIX = "/wiki/Dewgong_(Pok%C3%A9mon)"
  STOP_URL_SUFFIX  = "/wiki/Diancie_(Pok%C3%A9mon)"   # Will stop BEFORE scraping this pokemon
  
  START_DEXNUM = 87

  # Pages have a few different high-level structures
  XPATH_PREFIXES = [
    '//*[@id="mw-content-text"]/table[1]',
    '//*[@id="mw-content-text"]/table[2]',
    '//*[@id="mw-content-text"]/table[3]',
    '//*[@id="mw-content-text"]/table[4]'
  ]
  NAME_XPATH       = '/tr[1]/td/table/tr[1]/td/table/tr/td[1]/big/big/b'
  IMAGE_XPATH      = '/tr[1]/td/table/tr[2]/td/table/tr[1]/td/a/img'
  NEXT_URL_XPATH   = '/tr[1]/td[3]/table/tr/td[1]/a'

  def self.scrape_images
    # If the first and last images already exist, we'll assume they all do,
    #  and won't do anything
    return if File.file?('/app/assets/images/pokemon/001_bulbasaur.png') &&
       File.file?('/app/assets/images/pokemon/718_zygarde.png')

    next_url = START_URL_SUFFIX
    dexnum = START_DEXNUM

    while next_url != STOP_URL_SUFFIX do
      url = BULBAPEDIA_BASE + next_url
      puts url
      page = Nokogiri::HTML(open_resource(url))

      dexnum_string = dexnum.to_s.rjust(3, "0")
      name    = self.name(page)
      img_src = self.img_src(page)

      filename = "#{dexnum_string}_#{name}.png"
      filepath = "app/assets/images/pokemon/#{filename}"
      unless File.file? filepath
        File.open(filepath, "wb") do |f|
          puts "saving #{filepath}..."
          f.write(open_resource(img_src).read)
        end
      end

      dexnum += 1
      next_url = self.next_link(page)
      puts "\tnext link is #{BULBAPEDIA_BASE + next_url}"

      # sleep for a few seconds as simple page throttling
      sleep(rand(5..10))
    end
  end

  def self.open_resource(url)
    begin
      resource = open(url)
    rescue OpenURI::HTTPError => error
      # wait and try again
      sleep(rand(2..5))
      retry
    end
    resource
  end

  def self.name(html)
    self.node(html, NAME_XPATH).content.downcase
  end

  def self.img_src(html)
    self.node(html, IMAGE_XPATH)['src']
  end

  def self.next_link(html)
    self.node(html, NEXT_URL_XPATH)['href']
  end

  # Returns the node from the given xpath.
  # Tries a few different prefixes for different page structures
  def self.node(html, xpath)
    node = nil
    XPATH_PREFIXES.each do |prefix|
      break if node = html.xpath(prefix + xpath).first
    end
    node
  end
end