# == Schema Information
#
# Table name: sittingservices
#
#  id                  :integer          not null, primary key
#  service_name        :string
#  service_description :text
#  place_offered       :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'test_helper'

class SittingservicesControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
end
