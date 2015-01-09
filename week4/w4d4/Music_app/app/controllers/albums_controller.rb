class AlbumsController < ApplicationController
  def new
    @album = Album.new
    @bands = Band.all
    render :new
  end

  def create
    @album = Album.new(album_params)

    if @album.save
      redirect_to album_url(@album)
    else
      render json: @album.errors.full_message
    end
  end

  def show
    @album = Album.find(params[:id])
    @band = Band.find(@album.band_id)
    render :show
  end

  def update
    @album = Album.find(params[:id])

    if @album.update(album_params)
      redirect_to album_url(@album)
    else
      render :edit
    end
  end

  def index
    @albums = Album.all
    render :index
  end

  def edit
    @album = Album.find(params[:id])
    @bands = Band.all
    render :edit
  end

  def destroy
    @album = Album.find(params[:id])

    if @album.destroy
      redirect_to new_album_url
    else
      render :show
    end 
  end

  private

  def album_params
    params.require(:album).permit(:name, :album_type, :band_id)
  end
end
