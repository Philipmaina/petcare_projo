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

class BookingsController < ApplicationController


	# we want you to be signed in before you can actually book as it is one of the functional requirements of the app
	# otherwise there is no way we can get the petowner info to populate in the bookings table esp for the petowner_id field - because we are depending on that session hash to get info of petowner and if it isn't there then we're DOOMED
	before_action :require_petowner_signin , only: [:create_booking]


	# this is where the form data from confirmation bookings form reaches to allow for creation of a booking
	# most things validated frontend FOR NOW !!!
	def create_booking

		fail

		 # {"utf8"=>"✓",
 		 # "type_of_sitting_service"=>"1",
		 # "petschoseninshowpage"=>["Dog"],
		 # "dropoffdate"=>"2016-04-07",
		 # "pickupdate"=>"2016-04-09",
		 # "id"=>"3"}

		petsitter_id = params[:id] 
		sittingservice_id = params[:type_of_sitting_service]
		array_of_pets_to_be_booked_for = params[:petschoseninshowpage]
		dropoff_date = params[:dropoffdate].to_date
		pickup_date = params[:pickupdate].to_date





		petsitter_object = Petsitter.find(petsitter_id)
		sittingservice_object = Sittingservice.find(sittingservice_id)


		# residential area where we are booking for is that of the petsitter but we exclusively make a column of its own because we dont want to read off the petsitter table because later in time the petsitter might decide to change/shift
		residential_area_object = petsitter_object.residential_area



		# this gets the no_of_nights_days for booking
		if ( (sittingservice_object.service_name == "Normal boarding") || (sittingservice_object.service_name == "In home boarding") )

			# (pickup_date - dropoff_date)
			# => (2/1)
			# but we want 2 so we call to_integer

			count_of_charging_days_or_nights = (pickup_date - dropoff_date).to_i


		elsif (sittingservice_object.service_name == "Daycare")

			# if it's a daycare i have to drop off the pet early that day and pick it up later that day.
			# so i cant minus the dates coz i'll get 0, therefore i fix it to 1
			# NOTE TO FUTURE SELF: I MIGHT NEED TO CHANGE THE BUSINESS LOGIC BEHIND THIS AND THINK OF BOOKING DAYCARE FOR SEVERAL DAYS.
			count_of_charging_days_or_nights = 1
			
		end


		





	end


end
