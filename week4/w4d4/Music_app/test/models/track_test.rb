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

require 'test_helper'

class TrackTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
