class VenuesController < ApplicationController

  def index

    respond_to do |format|
      format.html
      format.json {
        concerts = Concert.displayed.all

        venues = concerts.uniq{|concert| concert.coordinates.to_a}.inject([]) {|memo, concert|
          hsh = {
            lat: concert.coordinates.last,
            lng: concert.coordinates.first,
            name: concert.venue
          }
          memo << hsh
          memo
        }

        render :json => venues.to_json
      }
      format.xml {
        @concerts = Concert.displayed.all

        render :xml => @concerts.to_xml
      }
    end
  end

  def show
    @concert = Concert.find params[:id]

    respond_to do |format|
      format.html
      format.json {
        render :json => @concert.to_json
      }
    end
  end

end
