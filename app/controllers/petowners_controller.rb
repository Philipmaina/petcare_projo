# == Schema Information
#
# Table name: petowners
#
#  id                    :integer          not null, primary key
#  first_name            :string
#  surname               :string
#  other_names           :string
#  date_of_birth         :date
#  personal_email        :string
#  contact_line_one      :string
#  contact_line_two      :string
#  profile_pic_file_name :string
#  residential_area_id   :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  password_digest       :string
#

class PetownersController < ApplicationController

	# _____________________________________________________________________

	# this says carry out this require_signin method before running all other actions except for new and create
	before_action :require_petowner_signin , except: [ :new_basic_predetails ,:create_basic_predetails ]

	before_action :require_correct_petowner , except: [ :new_basic_predetails ,:create_basic_predetails ]

	# ______________________________________________________________________



	# INSTANCE VARIABLES DO NOT LIVE ON AFTER THE ACTION RUNS IN RAILS

	# ---------------STEP 1 -----------------------------------------

	def new_basic_predetails
		@petowner = Petowner.new

		# we could have put what is below directly in the view but the controller's job is supposed to be to ask data from the model and set it up for the views - the view should be completely decoupled from the model( the view should never know of the model's existence )
		@all_residential_areas_in_nairobi = ResidentialArea.all
	end

	def create_basic_predetails

		# this helps avoid a common error called mass assignment where you don't whitelist the attributes you want to be stored from the form so a hacker could add his/her own attributes and change stuff in the db table that they shouldnt e.g admin value from 0 to 1
		petowner_first_step_params = params.require(:petowner).permit( :first_name , :surname , :other_names , :contact_line_one , :personal_email , :residential_area_id , :password , :password_confirmation  )

		@petowner = Petowner.new( petowner_first_step_params )

		# --THIS WILL HELP US IN THE PARTIAL OBJECT VALIDATION WHILE SAVING--
		@petowner.registration_step = "basic_predetails"

		if @petowner.save
			# if you create an account with us which in our case involves bypassing the first step of our multistep form we want to automatically sign in you otherwise you would have to sign in as a separate step
			session[:petowner] = @petowner.id


			# --------go to the NEXT(2nd) STEP----------------------
			# ---starts a whole request response cycle for STEP 2---
			redirect_to edit_petowner_personal_details_path(@petowner.id)
		else

			# NOTE TO FUTURE SELF:
			# ---Why include @all_residential_areas_in_nairobi again here before rendering ?
		 	# This is because it will give an error of undefined method `map' for nil:NilClass 
		 	# it does this because instance variables do not live on after an action runs - so the @all_residential_areas_in_nairobi in action new_basic_predetails dies off and now while we are in this new action called create_basic_predetails ,if we don't include the @all_residential_areas_in_nairobi again here, when we render the view new_basic_predetails, it won't know of that variable existing so an error arises.

			@all_residential_areas_in_nairobi = ResidentialArea.all
			# --stay on that 1st step and display errors for validation  
			render "new_basic_predetails"
		end

	end

	# -------------------------------------------------------------------

	# WE NEED TO CONSIDER BACK BUTTON FROM STEP 2 WHICH WOULD MEAN WE WANT TO UPDATE STEP 1 INFO BUT NOT CREATE NEW ONES A FRESH
	# ITS ALL ABOUT EDITING PETOWNER'S BASIC PREDETAILS

	def edit_basic_predetails
		@petowner = Petowner.find( params[:id] )

		# instance variable is killed off so we have to recreate it
		@all_residential_areas_in_nairobi = ResidentialArea.all

		render 'edit_basic_predetails'	
	end

	def update_basic_predetails

		@petowner = Petowner.find( params[:id] )

		@petowner.registration_step = "basic_predetails"

		petowner_first_step_params = params.require(:petowner).permit( :first_name , :surname , :other_names , :contact_line_one , :personal_email , :residential_area_id , :password , :password_confirmation  ) #prevents mass assignment

		if @petowner.update( petowner_first_step_params )
			
			redirect_to edit_petowner_personal_details_path(@petowner.id)
		else

			# instance variable is killed off so we have to recreate it
			@all_residential_areas_in_nairobi = ResidentialArea.all

			render 'edit_basic_predetails'

		end
		
	end



	# ---------------------STEP 2------------------------------------------
	def edit_petowner_personal_details
		@petowner = Petowner.find( params[:id] )	
	end

	def update_petowner_personal_details

		@petowner = Petowner.find( params[:id] )

		registration_step = "personal_details"

		petowner_second_step_params = params.require(:petowner).permit( :date_of_birth  , :contact_line_two , :profile_pic_file_name )

		if @petowner.update( petowner_second_step_params )	
			redirect_to petowner_add_pets_path(@petowner.id)
		else
			render 'edit_petowner_personal_details'
		end

	end
	# -------------------------------------------------------------------
	

	# -----------------------STEP 3 -------------------------------------
	# ----------3a)ACTUALLY ADDING PETS OF THE PETOWNER------------------
	
	def addpets
		@petowner = Petowner.find( params[:id] )
		@all_pets_in_system = Pettype.all
		
	end

	def create_pets

		@petowner = Petowner.find( params[:id] )

		# so firstly one can use the fail trick to see request parameters 
		# then we realize that when we get params[:petowner] we get another hash within it with a key called pets 
		# so if we get params[:petowner][:pets] we get the JSON string which looks like an array of json objects 
		# .parse() is a method that converts Json strings to ruby hashes, in essence it removes :(colons) and replaces with =>

		# [{\"name\":\"Martin\",
		# \"type\":\"Horse\",
		# \"years\":\"2\",
		# \"gender\":\"Female\"},
		# {\"name\":\"Philip\",
		# \"type\":\"Dog\",
		# \"years\":\"3\",
		# \"gender\":\"Male\"}] 

		    # WILL BECOME

		# [{"name"=>"Martin",
			# "type"=>"Horse",
			# "years"=>"2",
			# "gender"=>"Female"},
		#  {"name"=>"Philip",
			# "type"=>"Dog",
			# "years"=>"3",
			# "gender"=>"Male"}]

			# ONE CAN TEST THIS BEHAVIOUR WITH RAILS C

		array_of_pet_hashes = JSON.parse( params[:petowner][:pets] )

		array_of_pet_hashes.each do | pet_hash |


			@pet_object_to_be_stored_in_db = @petowner.pets.new #create pet from parent object(@petowner)

			@pet_object_to_be_stored_in_db.pet_name = pet_hash["name"]
			@pet_object_to_be_stored_in_db.years_pet_lived = pet_hash["years"]
			@pet_object_to_be_stored_in_db.gender = pet_hash["gender"]

			# because i have the pettype name not id i have to find a way to get that id because we want to store pettype_id not the name in the pets table.
			# so we get the pettype object whose name is equal to what is the value in the hash with the key type
			pettypeobject = Pettype.find_by( type_name: pet_hash["type"] )



			# because of that belongs_to association the pet has with pettype we are added/given the method .pettype to set the pettype of an object and we must equate it to an object. therefore we dont have to use .pettype_id

			@pet_object_to_be_stored_in_db.pettype = pettypeobject

			@pet_object_to_be_stored_in_db.save

		end

		redirect_to pet_owner_dashboard_path(@petowner.id)

	end


	def dashboard

		
		@petowner = Petowner.find( params[:id] )
		
	end

	def dashboard_edit_profile

		render 'edit_profile_on_dashboard'
		
	end

	def dashboard_notifications

		
	end

	def dashboard_bookings

		@bookings = Booking.where('start_date >= ? AND petsitter_acceptance_confirmation = ? ' , Time.now , true).order("start_date")

	end

	def dashboard_accountdetails
		
	end




	# ---------------------OTHER METHODS-----------------------------------
	# ~~~~~~~~THESE METHODS CANNOT BE ROUTED TO DIRECTLY ~~~~~~~~~~~~~~~
	private

		def require_correct_petowner

	      # checked if signed in petowner is the same as the one whose details are currently being updated,edited or deleted.

	      @petowner = Petowner.find( params[:id] )

	      # do something else blahblah...
	      unless current_petowner == @petowner
	        redirect_to root_path
	      end
	      
	    end




	
end
