class VenuesController < ApplicationController
  def index
    @concerts = Concert.displayed.all

    respond_to do |format|
      format.html
      format.json do
        grouped_concerts = @concerts.group_by(&:coordinates).map do |coordinates, concerts|
          {
            lat: coordinates.last,
            lng: coordinates.first,
            name: concerts.first.venue,
            count: concerts.size,
            concerts: concerts.map(&:for_api)
          }
        end

        render :json => grouped_concerts.to_json
      end
      format.xml do
        render :xml => @concerts.to_xml
      end
    end
  end

  def show
    @concert = Concert.find params[:id]

    respond_to do |format|
      format.html
      format.json do
        render :json => @concert.to_json
      end
    end
  end
end
