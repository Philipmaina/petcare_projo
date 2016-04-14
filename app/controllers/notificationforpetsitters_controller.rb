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

class NotificationforpetsittersController < ApplicationController

	# THE CREATION OF NOTIFICATIONS WAS ALREADY DONE INSIDE THE BOOKINGS MODEL USING AFTER_SAVE METHOD TO ENSURE NOTIFICATION IS IMMEDIATELY CREATED AFTER A BOOKING IS CREATED.

	def unread_booking_notifications

		petsitter_object = Petsitter.find( params[:id] ) #this is sent through the form chini ya maji(because ajax) as request parameters like below
		#  params = {"utf8"=>"✓", "id"=>"4"} 


		# i tack on .notificationforpetsitters to get all notifications of that petsitter because of has_many r/ship
		# then we want booking notification and those that are unread(read status is false)
		# ive ordered by id desc because the object with highest id number is the notification that was created soonest - ACTUALLY FOR UNREAD IT WON'T REALLY MATTER BUT SICE I WANT TO TACK ON ...3hrs ago for example i want them ordered with soonest at the top like in fb
		@notifications = petsitter_object.notificationforpetsitters.where( 'type_of_notification = ? AND read_status = ? ' , "Booking" , false ).order( "id desc" )

		respond_to  do | format |

			format.js # render a file called unread_booking_notifications.js.erb in notificationforpetsitters subdirectory of views
			
		end


		
	end

	def read_booking_notifications 

		petsitter_object = Petsitter.find( params[:id] )#this is sent through the form chini ya maji(because ajax) as request parameters like below
		#  params = {"utf8"=>"✓", "id"=>"4"} 


		# i tack on .notificationforpetsitters to get all notifications of that petsitter because of has_many r/ship
		# then we want booking notification and those that are unread(read status is false)
		# ive ordered by id desc because the object with highest id number is the notification that was created soonest - ACTUALLY FOR UNREAD IT WON'T REALLY MATTER BUT SINCE I WANT TO TACK ON ...3hrs ago for example i want them ordered with soonest at the top like in fb
		@notifications = petsitter_object.notificationforpetsitters.where( 'type_of_notification = ? AND read_status = ? ' , "Booking" , true ).order( "id desc" )

		respond_to  do | format |

			format.js # render a file called read_booking_notifications.js.erb in notificationforpetsitters subdirectory of views
			
		end
		
	end

	def review_notifications
		
	end


	# SINCE I DON'T WANT TO WASTE THE ACTIONS THAT ALREADY CAME WITH THE RESOURCE I MIGHT AS WELL USE THIS ONE 
	# WE ONLY LAND HERE AFTER PRESSING ACCEPT REQUEST GREEN BUTTON FROM THE BOOKING REQUEST AS A PETSITTER.
	# REMEMBER THE ONLY THING THAT IS POSSIBLE AND THAT SHOULD ALLOW TO BE CHANGED/UPDATED IS THE READ STATUS
	def update

		
		# {"_method"=>"patch", "id"=>"1"} - our request parameters

		notification_to_update = Notificationforpetsitter.find( params[:id] )

		# 1) FIRSTLY WE UPDATE THE READ STATUS OF THE NOTIFICATION
		# 2) THEN WE UPDATE THE PETSITTER_ACCEPTANCE_CONFIRMATION TO TRUE
		# 3) THEN WE REDIRECT TO DASHBOARD/NOTIFICATIONS FOR PETSITTERS - WE ONLY REDIRECT BECAUSE WE WANT TO SEE THE CHANGE IN THE NOTIFICATION TAB BY NO LONGER HAVING THE ALERT ICON TOGETHER WITH A DIGIT - WE CAN'T THEREFORE USE AJAX - HII STORY YA AJAX PIA TUMEZOEA SASA.
		
		# -----------------------1)-----------------------------------
		notification_to_update.read_status = true 
		notification_to_update.save
		# ------------------------------------------------------------

		# -----------------------2)-----------------------------------

		# so for step 2 lets first find the booking which we want to change the PETSITTER_ACCEPTANCE_CONFIRMATION value 
		booking_object_to_update = notification_to_update.booking


		booking_object_to_update.petsitter_acceptance_confirmation = true
		booking_object_to_update.save

		# -------------------------------------------------------------

		# -----------------------3)-------------------------------------
		redirect_to pet_sitter_dashboard_notification_path(notification_to_update.petsitter.id)
		# --------------------------------------------------------------




		
	end









	def destroy
		
	end
end
