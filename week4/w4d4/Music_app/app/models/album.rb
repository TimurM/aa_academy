# == Schema Information
#
# Table name: albums
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  album_type :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#  band_id    :integer
#

class Album < ActiveRecord::Base
  validates :name, :album_type, :band_id, presence: true

  belongs_to(
    :band,
    class_name: 'Band',
    foreign_key: :band_id,
    primary_key: :id
  )

  has_many(
    :tracks,
    class_name: 'Track',
    foreign_key: :album_id,
    primary_key: :id
  )

  ALBUM_TYPES = [
    "live",
    "studio"
  ]
end
