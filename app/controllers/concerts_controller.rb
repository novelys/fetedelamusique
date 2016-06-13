class ConcertsController < ApplicationController
  def index
    if params[:lat].present? && params[:lng].present?
      coordinates = [params[:lng].to_f, params[:lat].to_f]
      @concerts = Concert.displayed.geo_near(coordinates).max_distance(0.010.fdiv(6_371)).spherical.sort_by(&:time_start)
    else
      @concerts = Concert.displayed.all
    end

    respond_to do |format|
      format.html
      format.json {
        body = render_to_string partial: "concert", collection: @concerts, layout: false, formats: [:html]
        render json: {body: body}.to_json
      }
    end
  end

  def show
  end

  def new
    @concert = Concert.new
  end

  def create
    @concert = Concert.new create_params
    @concert.coordinates = create_coordinates

    if @concert.save
      render action: "thank_you"
    else
      render action: "new"
    end
  end

  def thank_you
  end

  protected

  def create_params
    params.require(:concert).permit(:artist, :artist_url, :genre, :description, :venue, :time_start, :time_end, :photo)
  end

  def create_coordinates
    params.permit(:lat, :lng).values.delete_if(&:blank?).reverse.map(&:to_f)
  end
end
