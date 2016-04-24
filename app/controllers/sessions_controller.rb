class SessionsController < ApplicationController

	# this method will fall through and look for view template that has the template that we need to show sign in link 
	def new
		
	end

	def create

		# ----------THIS IS IN CASE SOMEONE IS ALREADY LOGGED IN WE WANT TO CHUCK THEIR STUFF FROM SESSION before even doing anything
		# situation where someone else comes to the laptop and finds an already signed in person - they go to sign in page then sign in - if we don't do this we will have two people signed in - so we chuck anything in sessions hash

		if session.key?(:petsitter)

			session.delete(:petsitter)
			
		elsif session.key?(:petowner)

			session.delete(:petowner)

		end

		# -------------------------------------------------------------------


			

		# WE HAVE TO VERIFY THAT THE SUBMITTED EMAIL AND PASSWORD MATCH A USER IN EITHER TABLE
		# IF WE FIND A MATCHING USER WE STORE HIS UNIQUE ID IN SESSION HASH
		email = params[:personal_email]
		password = params[:password]

		# since we are using one form to login either a petsitter or petowner
		# we have to look through both tables of petsitter and petowner to see where the user has that email given.
		@user = ( Petsitter.find_by(personal_email: email ) ) || (Petowner.find_by(personal_email: email) ) || Admin.find_by( personal_email: email )
		# .find_by either returns nil or an object 
		# nil is like false in an if statement the object is like true

		# REMEMBER WE ALSO NEED TO COMPARE THE SUBMITTED PASSWORD WITH THE GIVEN PASSWORD IN THE FORM - TO FULLY AUTHENTICATE USER
		# has_secure_password gives us a .authenticate method that takes a plain text password from form encrypts it and compares it with object's .password_digest value - if they match the user object is returned otherwise false is returned.

		 # remember if @user is nil then we can't call .authenticate on nil so we check if user first exists then .authenticate , if first part fails everything fails
		if @user &&  @user.authenticate(password)

			# WE HAVE PETSITTERS OR PETOWNERS SO WE HAVE TO DISTINGUISH THEM WHEN CREATING THAT SESSION HASH
			# session data is small because cookie is small so we only store ids

			if @user.class.name == "Petsitter"

				# log in as petsitter
				session[:petsitter] = @user.id

				flash[:notice] = "Successfully signed in as petowner"

				redirect_to pet_sitter_dashboard_path(@user.id)

			elsif @user.class.name == "Petowner"

				# log in as petowner
				session[:petowner] = @user.id


				# the above should work for all cases
				# BUT NOW WE WANT TO CHECK IF THE SIGNING IN PET OWNER HAS HAD BOOKING(S) THAT BECAME A COMPLETED PET STAY(S)(which is satisfied by conditions that today > end date of booking AND petsitter_acceptance = TRUE AND completion_of_pet_stay=FALSE )
				# IF THEY HAVE ANY , THEN WE WANT TO CHANGE VALUE OF completion_of_pet_stay FIELD TO TRUE AND ALSO PRESENT THE PETOWNER WITH A RATINGS FORM FOR THE BOOKINGS WHICH HAVE BECOME COMPLETED PET STAYS
				# SO IF THEY HAVE ANY FORM LIKE THAT WE WILL END UP REDIRECTING TO THAT RATINGS FORM
				if @user.bookings.present? &&  @user.bookings.where('petsitter_acceptance_confirmation = ? AND end_date < ? AND completion_of_pet_stay = ?' , true , Time.now.to_date , false ).present?

					@array_of_all_bookings_that_became_pet_stays = @user.bookings.where('petsitter_acceptance_confirmation = ? AND end_date < ? AND completion_of_pet_stay = ?' , true , Time.now.to_date , false )



					@array_of_all_bookings_that_became_pet_stays.each do |element_of_booking_array|

					     element_of_booking_array.completion_of_pet_stay = true
					     element_of_booking_array.save

					end
					
					flash.now[:notice] = "Successfully signed in as pet owner"
					render 'ratings'

					
				else

					flash[:notice] = "Successfully signed in as pet owner"
					redirect_to pet_owner_dashboard_path(@user.id)
					
				end

			elsif @user.class.name == "Admin"

				# log in as admin
				session[:admin] = @user.id

				flash[:notice] = "Successfully signed in as ADMIN"

				redirect_to admin_dashboard_path(@user.id)
	
			end

			


		else

			flash.now[:alert] = "Invalid email or password combination!"
			render 'new'

		end



		
	end


	def destroy

		# there can only be one or the other at any one time
		if session.key?(:petsitter) 

			# In rails assigning this key a value effectively removes that key from the session 
			# this is different in ruby where the key would still exist but the value will be nil
			# for ruby one would need to do session.delete(key)
			# session.delete(key) will still work fine in rails 
			session[:petsitter] = nil

		elsif session.key?(:petowner)

			session[:petowner] = nil

		end
		 
		redirect_to root_url , notice: "You have been logged out"	 
		
	end
	
end
