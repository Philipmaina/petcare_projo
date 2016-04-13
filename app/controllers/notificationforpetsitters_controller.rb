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

		petsitter_object = params[:id] #this is sent through the form chini ya maji(because ajax) as request parameters like below
		#  params = {"utf8"=>"✓", "id"=>"4"} 


		# i tack on .notificationforpetsitters to get all notifications of that petsitter because of has_many r/ship
		# then we want booking notification and those that are unread(read status is false)
		# ive ordered by id desc because the object with highest id number is the notification that was created soonest - ACTUALLY FOR UNREAD IT WON'T REALLY MATTER BUT SICE I WANT TO TACK ON ...3hrs ago for example i want them ordered with soonest at the top like in fb
		@notifications = petsitter_object.notificationforpetsitters.where( 'type_of_notification = ? AND read_status = ? ' , "Booking" , false ).order( "id desc" )




		
	end

	def read_booking_notifications 

		petsitter_object = params[:id] #this is sent through the form chini ya maji(because ajax) as request parameters like below
		#  params = {"utf8"=>"✓", "id"=>"4"} 


		# i tack on .notificationforpetsitters to get all notifications of that petsitter because of has_many r/ship
		# then we want booking notification and those that are unread(read status is false)
		# ive ordered by id desc because the object with highest id number is the notification that was created soonest - ACTUALLY FOR UNREAD IT WON'T REALLY MATTER BUT SINCE I WANT TO TACK ON ...3hrs ago for example i want them ordered with soonest at the top like in fb
		@notifications = petsitter_object.notificationforpetsitters.where( 'type_of_notification = ? AND read_status = ? ' , "Booking" , true ).order( "id desc" )
		
	end

	def review_notifications
		
	end









	def destroy
		
	end
end
