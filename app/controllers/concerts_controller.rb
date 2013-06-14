class ConcertsController < ApplicationController

  def index

    if params[:lat].present? && params[:lng].present?
      coordinates = [params[:lat].to_f, params[:lng].to_f]
      @concerts = Concert.near(coordinates, 0.010, :units => :km).sort_by(&:time_start)
    else
      @concerts = Concert.all
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

end
