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

class BookingsController < ApplicationController


	# we want you to be signed in before you can actually book as it is one of the functional requirements of the app
	# otherwise there is no way we can get the petowner info to populate in the bookings table esp for the petowner_id field - because we are depending on that session hash to get info of petowner and if it isn't there then we're DOOMED
	before_action :require_petowner_signin 


	# this is where the form data from confirmation bookings form reaches to allow for creation of a booking
	# most things validated frontend FOR NOW !!!
	def create_booking


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

		string_of_pettypes_to_store_in_db = array_of_pets_to_be_booked_for.join(" , ")  #this string is what we'll store in actual pets_booked_for column


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



		# we can get the petowner from the session data
		# this is because for you to book you must be a signed in petowner

		@petowner_who_is_booking = current_petowner # this will be the petowner object booking


		# this is to get the total_price 
		# firstly we get the price charge of the petsitter at the moment (the very second this booking happens) we can't wait for later because the petsitter may edit the price and we don't want a conflict where a petowner thought they were paying this but are presented with a different price
		# we then multiply with the count_of_charging_days_or_nights 
		total_price_of_stay = petsitter_object.night_charges * count_of_charging_days_or_nights




		# ------------creating the booking object-------------------------

		@booking = @petowner_who_is_booking.bookings.new #petowner_id will be immediately filled

		@booking.sittingservice = sittingservice_object
		@booking.residential_area = residential_area_object
		@booking.petsitter = petsitter_object
		@booking.start_date = dropoff_date
		@booking.end_date = pickup_date
		@booking.pets_booked_for = string_of_pettypes_to_store_in_db
		@booking.no_of_night_days_for_pet_stay = count_of_charging_days_or_nights
		@booking.total_price_of_stay = total_price_of_stay
		@booking.save

		redirect_to pet_owner_dashboard_bookings_path(@petowner_who_is_booking.id) , notice: " Successfully booked for a pet stay!!Check in pending bookings "


	end

	# --BUSINESS RULES EXPLAINING UPCOMING,PENDING,ONGOING,PAST PET STAYS AND ARCHIVED BOOKINGS



		# ------explanation goes here-----------------





	# ------------------------------------------------------------------------

	# get all bookings which have been agreed/confirmed by petsitters and havent happened yet - close to happening
	def upcoming_bookings
		# we want to order the soonest booking at the top of the list even if it is at the past - then we'll remove those past ones( we use asc order )
		# we remove those that are at the past i.e when start_date <= date today
		# we also need to check for petsitter_acceptance_confirmation because that will tell us whether the petsitter has agreed to care for our pet(s)
		 # Parameters: {"utf8"=>"✓", "id"=>"9"}
		petowner_of_concern = Petowner.find( params[:id] )
		@bookings = petowner_of_concern.bookings.where('start_date > ? AND petsitter_acceptance_confirmation = ? ' , Time.now.to_date , true).order("start_date")

		respond_to  do | format |

			format.js # render a file called upcoming_bookings.js.erb in bookings subdirectory of views
			
		end

	end



	# here we are checking for bookings which are in the future(haven't happened) and the petsitter has yet to confirm whether or not he/she will care for the pets
	def pending_bookings

		petowner_of_concern = Petowner.find( params[:id] )
		@bookings = petowner_of_concern.bookings.where('start_date > ? AND petsitter_acceptance_confirmation = ? ' , Time.now.to_date , false).order("start_date")

		respond_to  do | format |

			format.js # render a file called pending_bookings.js.erb in bookings subdirectory of views
			
		end


		
	end

	def ongoing_bookings

		petowner_of_concern = Petowner.find( params[:id] )
		@bookings = petowner_of_concern.bookings.where('start_date <= ? AND end_date >= ? AND petsitter_acceptance_confirmation = ? ' , Time.now.to_date , Time.now.to_date , true).order("start_date")

		respond_to  do | format |

			format.js # render a file called ongoing_bookings.js.erb in bookings subdirectory of views
			
		end

		
	end

	# these are bookings that actually happened but are in the past
	# that means the petsitter_acceptance_confirmation is true but the end_date is less than today(the date today is way ahead of the enddate)
	def past_pet_stays
		petowner_of_concern = Petowner.find( params[:id] )
		@bookings = petowner_of_concern.bookings.where('end_date < ? AND petsitter_acceptance_confirmation = ? ' , Time.now.to_date , true).order("start_date desc")
		# the order clause is desc because if i had a pet stay that ended 8/4/2016 and another that ended 17/4/2016 and another that ended 4/4/2016 and assuming today is 19/4/2016 - i would want them arranged from 17/4/2016(the first one in list) , then 8/4/2016 , finally 4/4/2016 - WHICH IS DESCENDING ORDER

		respond_to  do | format |

			format.js # render a file called past_pet_stays.js.erb in bookings subdirectory of views
			
		end
		
	end


	# THIS IS FOR THE BOOKINGS THAT NEVER HAPPENED PROBABLY BECAUSE THE SITTER DIDNT RESPOND IN TIME
	# so the date today is ahead(greater than the start_date ) plus the petsitter_acceptance_confirmation is still false
	def archived_bookings
		petowner_of_concern = Petowner.find( params[:id] )
		@bookings = petowner_of_concern.bookings.where('start_date <= ? AND petsitter_acceptance_confirmation = ? ' , Time.now.to_date , false).order("start_date desc")

		respond_to  do | format |

			format.js # render a file called archived_bookings.js.erb in bookings subdirectory of views
			
		end
		
	end






	def update_rating_of_booking

		
		# params = {"utf8"=>"✓",
			 # "authenticity_token"=>"2rL4zBJBZWb+gzF4FmVuMTAO6GfeX5sS1dJ+bIy4wPm89K+tE5Unw7AAEubsPk7riNSU+P7ZOpbF7zJblY8wqQ==",
			 # "bookings_that_become_pet_stays"=>{ 
					 # "1"=>{"id"=>"1", "rating_after_complete_pet_stay"=>"3"},
					 # "3"=>{"id"=>"3","rating_after_complete_pet_stay"=>"4"}
					# }
			# }
		# THE ABOVE IS WHAT WE GET BUT NOT ESSENTIALLY WHAT WE WANT 
		# WE WANT AN ARRAY OF HASHES LIKE BELOW
		#  "bookings_that_become_pet_stays" => [ 
				# {"id"=>"1", "rating_after_complete_pet_stay"=>"3"}, 
				# {"id"=>"3", "rating_after_complete_pet_stay"=>"4"}
			# ] 

		# therefore we first of all get the key "bookings_that_become_pet_stays" and make its value not be a hash of hashes but we take only the values and conver to an array - all we are doing is chucking "1" => and "3" =>
		params[:bookings_that_become_pet_stays] =  params[:bookings_that_become_pet_stays].values

		params["bookings_that_become_pet_stays"].each do |hash_inside_array|

			# we firstly update rating of a booking/pet stay
		    booking_to_update_rating = Booking.find( hash_inside_array[:id] )
		    booking_to_update_rating.rating_after_complete_pet_stay = hash_inside_array[:rating_after_complete_pet_stay]

		    if booking_to_update_rating.save

			    # then immediately after we create a notification for petsitters telling them of the rating they've received
			    notification = booking_to_update_rating.notificationforpetsitters.new( petsitter: booking_to_update_rating.petsitter , type_of_notification: "Rating" )
			    notification.save

			    redirect_to pet_owner_dashboard_path(booking_to_update_rating.petowner_id) , notice: "Thanks for being a good sport and rating your pet carer(s) :) :)"

			end

		end

		
	end






	private

		def require_correct_petowner
			
		end



end
