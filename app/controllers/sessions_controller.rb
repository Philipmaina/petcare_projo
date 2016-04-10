class SessionsController < ApplicationController

	# this method will fall through and look for view template that has the template that we need to show sign in link 
	def new
		
	end

	def create

		# ----------THIS IS IN CASE SOMEONE IS ALREADY LOGGED IN WE WANT TO CHUCK THEIR STUFF FROM SESSION before even doing anything

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
		@user = ( Petsitter.find_by(personal_email: email ) ) || (Petowner.find_by(personal_email: email) )
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

				flash[:notice] = "Successfully signed in as #{@user.class.name} and name is #{@user.first_name}"

				redirect_to pet_sitter_dashboard_path(@user.id)

			elsif @user.class.name == "Petowner"

				# log in as petowner
				session[:petowner] = @user.id

				flash[:notice] = "Successfully signed in as #{@user.class.name} and name is #{@user.first_name}"

				redirect_to pet_owner_dashboard_path(@user.id)
	
			end

			


		else

			flash.now[:alert] = "Invalid name or password"
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
