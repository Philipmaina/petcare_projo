# == Schema Information
#
# Table name: notificationforpetowners
#
#  id                   :integer          not null, primary key
#  petowner_id          :integer
#  booking_id           :integer
#  read_status          :boolean          default(FALSE)
#  type_of_notification :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

module NotificationforpetownersHelper
end
