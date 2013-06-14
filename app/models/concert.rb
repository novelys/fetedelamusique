class Concert
  include Mongoid::Document
  include Mongoid::Timestamps

  field :artist, type: String
  field :artist_url, type: String, default: nil
  field :genre, type: String, default: nil
  field :time_start, type: Time
  field :time_end, type: Time
  field :is_official, type: Boolean, default: false
  field :description, type: String, default: nil
  field :venue, type: String
  field :venue_alt, type: String

  field :coordinates, type: Array

  index({ coordinates: "2d" }, { min: -200, max: 200 })

  validates_presence_of :artist, :time_start, :time_end

  def self.load_official_concerts
    f = File.open("doc/strasbourg-fete-de-la-musique-2013.xml")
    doc = Nokogiri::XML(f)
    f.close

    counter = 0

    doc.xpath("//band").each{|band_node|

      live_node = band_node.xpath("live").first
      location_node = band_node.xpath("live/location").first
      coordinates = [ location_node["lon"], location_node["lat"] ]

      if (loc = location_node.xpath("name").first.content).present?
        venue = loc
      end
      if (loc = location_node.xpath("name").first["alt"]).present?
        venue_alt = loc
      end

      concert = Concert.new({
        is_official: true,
        artist: band_node.xpath("name").first.content,
        artist_url: band_node["url"],
        genre: band_node.xpath("genre").first.content,
        description: band_node.xpath("description").first.content,
        coordinates: coordinates,
        venue: venue,
        venue_alt: venue_alt,
        time_start: live_node["start"],
        time_end: live_node["end"]
      })

      concert.save!

      counter+=1
    }

    counter
  end
end
