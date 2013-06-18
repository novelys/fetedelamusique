class ConcertsController < ApplicationController
  def index
    if params[:lat].present? && params[:lng].present?
      coordinates = [params[:lat].to_f, params[:lng].to_f]
      @concerts = Concert.near(coordinates, 0.010, :units => :km).displayed.sort_by(&:time_start)
    else
      @concerts = Concert.displayed.all
    end

    respond_to do |format|
      format.html
      format.json {
        body = render_to_string :template => "/concerts/index.html.haml", :collection => @concerts, :layout => false
        render :json => {body: body}.to_json
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

    if @concert.save
      render :action => "thank_you"
    else
      render :action => "new"
    end
  end

  def thank_you
  end

  protected

  def create_params
    params.require(:concert).permit(:artist, :artist_url, :genre, :description, :venue, :time_start, :time_end, :photo)
  end
end
