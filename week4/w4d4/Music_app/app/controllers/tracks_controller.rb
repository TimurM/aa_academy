class TracksController < ApplicationController

  def new
    @track = Track.new
    @albums = Album.all
    render :new
  end

  def create
    @track = Track.new(track_params)

    if @track.save
      redirect_to track_url(@track)
    else
      @albums = Album.all
      render  :new
    end
  end

  def update
    @track = Track.find(params[id])

    if @track.update(track_params)
      redirect_to track_url(@track)
    else
      render :edit
    end
  end

  def index
    @tracks = Tracks.all
  end

  def show
    @track = Track.find(params[:id])
  end

  def edit
    @track = Track.find(params[:id])
    render :edit
  end

  def destroy
    @track = track.find(params[:id])
    if @track.destroy
      redirect_to new_tracks_url
    else
      render :show
    end
  end

  private

  def track_params
    params.require(:track).permit(:track_name, :album_id, :track_type, :lyrics)
  end
end
