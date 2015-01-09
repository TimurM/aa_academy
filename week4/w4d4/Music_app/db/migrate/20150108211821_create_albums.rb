class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :name, null: false
      t.string :album_type, null: false

      t.timestamps
    end
  end
end
