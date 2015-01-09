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

require 'test_helper'

class AlbumTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
