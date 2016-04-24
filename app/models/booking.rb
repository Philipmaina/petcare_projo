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
#  rating_after_complete_pet_stay    :integer
#

class Booking < ActiveRecord::Base




  #~~~~~~~~~~~~~~~~ relationships~~~~~~~~~~~~~~~~~~~~~~
  belongs_to :petowner
  belongs_to :petsitter
  belongs_to :residential_area
  belongs_to :sittingservice


  has_many :notificationforpetsitters #it's good practice to reciprocate the r/ship BUT IT IS VERY IMPORTANT TO NOTE THAT THERE CAN ONLY BE ONE NOTIFICATION FOR A BOOKING - IT IS LIKE WE'RE CHEATING BUT LEGALLY 
  # A NOTIFICATION MUST ALWAYS BE TIED TO(BELONG TO) A BOOKING FOR THE NOTIFICATION TO MAKE SENSE.
  # NOTE TO FUTURE SELF: SEE HOW TO USE HAS_ONE R/SHIP
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~





# -----REMEMBER WE WANT TO CREATE A NOTIFICATION IMMEDIATELY A BOOKING IS SAVED
# ------------------------------CALLBACKS---------------------------------------
  # Callbacks are methods that get called at certain moments of an object's life cycle. 
  # WITH CALLBACKS IT IS POSSIBLE TO WRITE CODE THAT WILL RUN WHENEVER AN ACTIVE RECORD OBJECT IS CREATED, SAVED, UPDATED, DELETED, VALIDATED, OR LOADED FROM THE DATABASE.

  # Once the active record object saved some method will be fired in that scenario we have to use the after_save callback.
  # WE USE AFTER_CREATE OVER AFTER_SAVE BECAUSE WE WANT THIS TO WORK ONCE ONLY WHEN A NEW BOOKING OBJECT IS CREATED IS WHEN WE WANT THE NOTIFICATION OBJECT TO ALSO BE CREATED. OTHERWISE IF WE USE AFTER_SAVE A NEW NOTIFICATION OBJECT WILL BE SAVED EVEN WHEN YOURE UPDATING SOME ATTRIBUTE OF THE BOOKING OBJECT BECAUSE UPDATE INVOLVES SAVING.
  # !!!!NOTE TO FUTURE SELF: BE EXTREMELY CAREFUL OF THE ABOVE LATER
  after_create :notification_booking_petsitter_creation


# ------------------------------------------------------------------------------

  def notification_booking_petsitter_creation

  	notification_object = self.notificationforpetsitters.new

  	notification_object.petsitter = self.petsitter
  	notification_object.type_of_notification = "Booking"
  	notification_object.save
  	
  end


end
