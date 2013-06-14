module ApplicationHelper

  def concert_venue(concert)
    if concert.venue.present? || concert.venue_alt.present?
      content_tag "p" do
        ary = []
        ary << concert.venue     if concert.venue.present?
        ary << concert.venue_alt if concert.venue_alt.present?
        case ary.size
        when 2
          "#{ary.first} (#{ary.last})"
        when 1
          ary.first
        end
      end
    end
  end
end
