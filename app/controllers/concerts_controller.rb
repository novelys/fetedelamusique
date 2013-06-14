class ConcertsController < ApplicationController

  def index

    respond_to do |format|

      format.json {
        coordinates = [params[:lat].to_f, params[:lng].to_f]

        concerts = Concert.near(coordinates, 0.010, :units => :km).sort_by(&:time_start)

        body = concerts.map{|concert| "<h1>"+concert.artist+"</h1><img src='#{ concert.photo.url(:small) }' /><br/>"+concert.description}.join("")

        render :json => {body: body}.to_json
      }
    end

  end

  def show
  end

end
