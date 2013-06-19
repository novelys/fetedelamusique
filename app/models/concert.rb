class Concert
  include Mongoid::Document
  include Mongoid::Timestamps
  include Geocoder::Model::Mongoid
  include Mongoid::Paperclip

  field :artist, type: String
  field :artist_url, type: String, default: nil
  field :genre, type: String, default: nil
  field :time_start, type: Time
  field :time_end, type: Time
  field :is_official, type: Boolean, default: false
  field :is_validated, type: Boolean, default: false
  field :description, type: String, default: nil
  field :venue, type: String
  field :venue_alt, type: String
  field :contact_email, type: String

  field :coordinates, type: Array, default: nil

  has_mongoid_attached_file :photo, {
    styles: {
      small: "320x240#"
    }
  }

  reverse_geocoded_by :coordinates

  index({ coordinates: "2d" }, { min: -200, max: 200 })

  validates_presence_of :artist, :time_start, :time_end, :coordinates

  scope :displayed, where(:coordinates.exists => true).any_of({is_official: true}, {is_validated: true})

  attr_accessor :lat, :lng

  after_validation do |concert|
    if concert.is_validated == "1"
      concert.is_validated = true
    else
      concert.is_validated = false
    end
  end
    
  def concert_id
    id.to_s
  end

  def self.load_official_concerts
    f = File.open("doc/strasbourg-fete-de-la-musique-2013.xml")
    doc = Nokogiri::XML(f)
    f.close

    counter = 0

    doc.xpath("//band").each{|band_node|

      picture_url = band_node.xpath("picture/url").try(:first).try(:content)
      live_node = band_node.xpath("live").first
      location_node = band_node.xpath("live/location").first
      coordinates = [ location_node["lon"].to_f, location_node["lat"].to_f ]

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
        time_end: live_node["end"],
        photo: picture_url.blank? ? nil : URI.parse(picture_url)
      })

      concert.save!

      counter+=1
    }

    counter
  end
end
