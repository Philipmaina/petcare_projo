# == Schema Information
#
# Table name: bookings
#
#  id                                :integer          not null, primary key
#  start_date                        :date
#  end_date                          :date
#  petowner_id                       :integer
#  pets_booked_for                   :string
#  petsitter_id                      :integer
#  residential_area_id               :integer
#  no_of_night_days_for_pet_stay     :integer
#  total_price_of_stay               :decimal(, )
#  sittingservice_id                 :integer
#  reason_of_booking                 :string
#  petsitter_acceptance_confirmation :boolean          default(FALSE)
#  petsitter_booking_cancellation    :boolean          default(FALSE)
#  completion_of_pet_stay            :boolean          default(FALSE)
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#

class Booking < ActiveRecord::Base




  #~~~~~~~~~~~~~~~~ relationships~~~~~~~~~~~~~~~~~~~~~~
  belongs_to :petowner
  belongs_to :petsitter
  belongs_to :residential_area
  belongs_to :sittingservice
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
end
