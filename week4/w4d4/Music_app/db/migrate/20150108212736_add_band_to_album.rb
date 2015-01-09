class AddBandToAlbum < ActiveRecord::Migration
  def change
    add_column :albums, :band_id, :integer
  end
end
