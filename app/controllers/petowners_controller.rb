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
#  ResidentialArea_id    :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class PetownersController < ApplicationController

	# INSTANCE VARIABLES DO NOT LIVE ON AFTER THE ACTION RUNS IN RAILS

	# ---------------STEP 1 -----------------------------------------

	def new_basic_predetails
		@petowner = Petowner.new

		# we could have put what is below directly in the view but the controller's job is supposed to be to ask data from the model and set it up for the views - the view should be completely decoupled from the model( the view should never know of the model's existence )
		@all_residential_areas_in_nairobi = ResidentialArea.all
	end

	def create_basic_predetails

		# this helps avoid a common error called mass assignment where you don't whitelist the attributes you want to be stored from the form so a hacker could add his/her own attributes and change stuff in the db table that they shouldnt e.g admin value from 0 to 1
		petowner_first_step_params = params.require(:petowner).permit( :first_name , :surname , :other_names , :contact_line_one , :personal_email , :ResidentialArea_id )

		@petowner = Petowner.new( petowner_first_step_params )

		# --THIS WILL HELP US IN THE PARTIAL OBJECT VALIDATION WHILE SAVING--
		@petowner.registration_step = "basic_predetails"

		if @petowner.save 
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

	# --------------------------------------------------------------------



	# ---------------------STEP 2------------------------------------------
	def edit_petowner_personal_details
		@petowner = Petowner.find( params[:id] )	
	end

	def update_petowner_personal_details

		@petowner = Petowner.find( params[:id] )

		registration_step = "personal_details"

		petowner_second_step_params = params.require(:petowner).permit( :date_of_birth  , :contact_line_two , :profile_pic_file_name )

		if @petowner.update( petowner_second_step_params )	

		else
			render 'edit_petowner_personal_details'
		end

	end
	# --------------------------------------------------------------------

	# -----------------------STEP 3 --------------------------------------
	# ----------3a)ACTUALLY ADDING PETS OF THE PETOWNER--------------------


	# ---------------------OTHER METHODS-----------------------------------
	# ~~~~~~~~~~~THESE METHODS CANNOT BE ROUTED TO DIRECTLY ~~~~~~~~~~~~~~~~~~
	private




	
end
