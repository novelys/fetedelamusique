require "csv"

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

  geocoded_by :venue
  after_validation :geocode # auto-fetch coordinates

  index({ coordinates: "2d" }, { min: -200, max: 200 })

  validates_presence_of :artist, :time_start, :time_end

  scope :displayed, -> { where(:coordinates.exists => true).any_of({is_official: true}, {is_validated: true}) }

  attr_accessor :lat, :lng

  # rails_admin do
  #   list do
  #     field :is_official do
  #       label "Officiel"
  #     end
  #     field :is_validated do
  #       label "Validé"
  #     end
  #     field :created_at do
  #       label "Crée à"
  #     end
  #     field :artist do
  #       label "Artiste"
  #     end
  #    end
  # end

  before_validation do |concert|
    if concert.is_validated == "1"
      concert.is_validated = true
    elsif concert.is_validated == "0"
      concert.is_validated = false
    end
    if concert.is_official == "1"
      concert.is_official = true
    elsif concert.is_official == "0"
      concert.is_official = false
    end
    true
  end

  def concert_id
    id.to_s
  end

  def for_api
    keys = %w(is_official artist artist_url genre description venue_alt time_start time_end)
    hsh = attributes.slice(*keys)
    hsh['photo'] = photo.url
    hsh
  end

  def self.load_official_concerts filename = nil
    counter = 0
    filename ||= "doc/pgm-fdm-2016.csv"
    venue = nil
    CSV.foreach(filename, headers: true) do |row|

      venue = "#{row[1]}, Strasbourg" if row[1].present?
      time_start_raw = row[2]
      time_end_raw   = row[3]

      if time_start_raw.present?
        hour, minute = time_start_raw.split("h").map(&:to_i)
        if hour < 3
          time_start = Time.new 2016, 6, 22, hour, minute
        else
          time_start = Time.new 2016, 6, 21, hour, minute
        end
      end

      if time_end_raw.present?
        hour, minute = time_end_raw.split("h").map(&:to_i)
        if hour < 3
          time_end = Time.new 2016, 6, 22, hour, minute
        else
          time_end = Time.new 2016, 6, 21, hour, minute
        end
      end

      concert = Concert.new({
        is_official: true,
        artist: row[4],
        artist_url: row[6],
        genre: row[5],
        description: row[7],
        venue: venue,
        venue_alt: row[0],
        time_start: time_start,
        time_end: time_end
      })

      counter += 1 if concert.save
    end

    counter
  end
end
