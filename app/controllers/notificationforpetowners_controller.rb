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

class NotificationforpetownersController < ApplicationController


	def unread_booking_notifications

		# {"utf8"=>"✓", "id"=>"7"}
		petowner_object = Petowner.find( params[:id] )#this is sent through the form chini ya maji(because ajax) as request parameters as shown above

		# we order by id desc so that the soonest event is shown first the one 
		@notifications = petowner_object.notificationforpetowners.where( 'type_of_notification = ? AND read_status = ? ' , "Booking" , false ).order("id desc")

		respond_to  do | format |

			format.js # render a file called unread_booking_notifications.js.erb in notificationforpetowners subdirectory of views
			
		end


	end


	def read_booking_notifications

		#  Parameters: {"utf8"=>"✓", "id"=>"7"}

		petowner_object = Petowner.find( params[:id] )#this is sent through the form chini ya maji(because ajax) as request parameters as shown above

		# we order by id desc so that the soonest event is shown first the one 
		@notifications = petowner_object.notificationforpetowners.where( 'type_of_notification = ? AND read_status = ? ' , "Booking" , true ).order("id desc")

		respond_to  do | format |

			format.js # render a file called read_booking_notifications.js.erb in notificationforpetowners subdirectory of views
			
		end

		
	end

	# THIS IS WHEN YOU CLICK THE MARK AS READ BUTTON IN NOTIFICATION FOR PETOWNER - I'LL USE THIS ACTIONS SO AS NOT TO WASTE ACTIONS BUT ALSO COZ THE ONLY THING WE GET TO UPDATE IN A NOTIFICATION IS THE READ STATUS SO IT MAKES SENSE IF WHAT WE WANT TO DO FALLS IN THIS ACTION
	def update


		# {"_method"=>"patch", "id"=>"1"}
		notification_to_update = Notificationforpetowner.find( params[:id] )
		notification_to_update.read_status = true
		notification_to_update.save

		redirect_to pet_owner_dashboard_notification_path(notification_to_update.petowner.id)
		
	end
end
