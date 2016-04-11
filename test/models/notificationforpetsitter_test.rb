# == Schema Information
#
# Table name: notificationforpetsitters
#
#  id                   :integer          not null, primary key
#  petsitter_id         :integer
#  booking_id           :integer
#  read_status          :boolean          default(FALSE)
#  type_of_notification :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

require 'test_helper'

class NotificationforpetsitterTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
