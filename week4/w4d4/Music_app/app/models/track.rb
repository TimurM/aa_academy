# == Schema Information
#
# Table name: tracks
#
#  id         :integer          not null, primary key
#  track_name :string(255)      not null
#  album_id   :integer          not null
#  track_type :string(255)      not null
#  lyrics     :text
#  created_at :datetime
#  updated_at :datetime
#

class Track < ActiveRecord::Base
  validates :track_name, :track_type, :album_id, presence: true

  belongs_to(
    :album,
    class_name: 'Album',
    foreign_key: :album_id,
    primary_key: :id
  )

  has_one(
    :band,
    through: :album,
    source: :band
  )

  TRACK_TYPES = [
    "bonus",
    "regular"
  ]
end
