# == Schema Information
#
# Table name: petsitters
#
#  id                                 :integer          not null, primary key
#  first_name                         :string
#  surname                            :string
#  other_names                        :string
#  date_of_birth                      :date
#  ResidentialArea_id                 :integer
#  personal_email                     :string
#  contact_no_one                     :string
#  contact_no_two                     :string
#  no_of_yrs_caring                   :integer
#  no_of_pets_owned                   :integer
#  type_of_home                       :string
#  presence_of_open_area_outside_home :boolean
#  work_situation                     :string
#  day_charges                        :integer
#  night_charges                      :integer
#  default_pic_file_name              :string
#  listing_name                       :string
#  profile_description                :text
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null
#

class PetsittersController < ApplicationController

	# ~~~~~~~~~~~~~~FIRST STEP OF MULTISTEP FORM~~~~~~~~~~~~
	def new_basic_predetails
		@petsitter = Petsitter.new #object that form will bind to 
		
		# we could have put what is below directly in the view but the controller's job is supposed to be to ask data from the model and set it up for the views - the view should be completely decoupled from the model( the view should never know of the model's existence )
		@all_residential_areas_in_nairobi = ResidentialArea.all
	end

	def create_basic_predetails
	
		petsitter_first_step_params = params.require(:petsitter).permit( :first_name , :surname , :other_names , :contact_line_one , :personal_email , :ResidentialArea_id ) #prevents mass assignment

		@petsitter = Petsitter.new( petsitter_first_step_params )

		# --THIS WILL HELP US IN THE PARTIAL OBJECT VALIDATION WHILE SAVING--
		@petsitter.registration_step = "basic_predetails"

		if @petsitter.save
			redirect_to edit_petsitter_personal_details_path(@petsitter.id)	
		else

			# NOTE TO FUTURE SELF:
			# ---Why include @all_residential_areas_in_nairobi again here before rendering ?
		 	# This is because it will give an error of undefined method `map' for nil:NilClass 
		 	# it does this because instance variables do not live on after an action runs - so the @all_residential_areas_in_nairobi in action new_basic_predetails dies off and now while we are in this new action called create_basic_predetails ,if we don't include the @all_residential_areas_in_nairobi again here, when we render the view new_basic_predetails, it won't know of that variable existing so an error arises.

			@all_residential_areas_in_nairobi = ResidentialArea.all

			render 'new_basic_predetails'
		end

	end

	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


	# -----STEP 1 OF MULTISTEP FORM BUT WHEN EDITING A PET SITTER'S BASIC DETAILS--------------------------------------------------- 
	# BELOW IS A WAY TO EDIT DETAILS OF THE FIRST STEP(TO ALLOW BACK BUTTON FROM SECOND STEP BACK TO HERE and ALSO LATER IF PETSITTER WANTS TO EDIT DETAILS IN THAT FIRST FORM like surname , or contact_line_one)
	def edit_basic_predetails
		@petsitter = Petsitter.find( params[:id] )

		# instance variable is killed off so we have to recreate it
		@all_residential_areas_in_nairobi = ResidentialArea.all

		render 'edit_basic_predetails'	
	end

	def update_basic_predetails

		@petsitter = Petsitter.find( params[:id] )

		@petsitter.registration_step = "basic_predetails"

		petsitter_first_step_params = params.require(:petsitter).permit( :first_name , :surname , :other_names , :contact_line_one , :personal_email , :ResidentialArea_id ) #prevents mass assignment

		if @petsitter.update( petsitter_first_step_params )

			redirect_to edit_petsitter_personal_details_path(@petsitter.id)
		else

			# instance variable is killed off so we have to recreate it
			@all_residential_areas_in_nairobi = ResidentialArea.all

			render 'edit_basic_predetails'

		end

	end
	# -----------------------------------------------------------------






	# ~~~~~~~~~~~~~~~~SECOND STEP OF MULTISTEP FORM~~~~~~~~~~~~~~~~~~~~~

	def edit_petsitter_personal_details
		@petsitter = Petsitter.find( params[:id] )
		# then renders view with next step(2nd) form
	end

	def update_petsitter_personal_details

		@petsitter = Petsitter.find( params[:id] )

		@petsitter.registration_step = "personal_details"

		petsitter_second_step_params = params.require(:petsitter).permit( :date_of_birth , :contact_line_two , :listing_name , :profile_description , :default_pic_file_name )

		if @petsitter.update( petsitter_second_step_params )
			redirect_to edit_experience_and_skills_details_path(@petsitter.id)
		else
			render "edit_petsitter_personal_details"
		end
		
	end

	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	# ~~~~~~~~~~~~~~~~THIRD STEP OF MULTISTEP FORM~~~~~~~~~~~~~~~~~~~~~

	def edit_petsitter_experience_and_skills_details
		@petsitter = Petsitter.find( params[:id] )
		@all_work_situations = Petsitter.all_work_situations_they_can_have
	end

	def update_petsitter_experience_and_skills_details
		

		@petsitter = Petsitter.find( params[:id] )

		# in this case i don't need a registration step because there is nothing to validate the partial object in the models - the validation is done frontend

		petsitter_third_step_params = params.require(:petsitter).permit( :work_situation , :no_of_yrs_caring , :no_of_pets_owned)

		if @petsitter.update( petsitter_third_step_params )
			redirect_to edit_petsitter_home_details_path( @petsitter.id )
		else

			# instance variables get killed off after an action runs so after edit_petsitter_experience_and_skills_details action we need to again declare this variable otherwise it will give an error of nil:Nil class when there are validation errors
			
			@all_work_situations = Petsitter.all_work_situations_they_can_have

			render 'edit_petsitter_experience_and_skills_details'
		end

	end
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	# ~~~~~~~~~~~~~~~~FOURTH STEP OF MULTISTEP FORM~~~~~~~~~~~~~~~~~~~~~~

	def edit_petsitter_home_details
		@petsitter = Petsitter.find( params[:id] )
		@all_types_of_homes = Petsitter.all_types_of_homes_to_live_in
	end

	def update_petsitter_home_details

		@petsitter = Petsitter.find( params[:id] )

		petsitter_fourth_step_params = params.require(:petsitter).permit( :type_of_home , :presence_of_open_area_outside_home )

		if @petsitter.update( petsitter_fourth_step_params )
			redirect_to edit_petsitter_charges_plus_calendar_path(@petsitter.id)
		else

			# instance variables get killed off after an action runs so after edit_petsitter_home_details action we need to again declare this variable otherwise it will give an error of nil:Nil class when there are validation errors

			@all_types_of_homes = Petsitter.all_types_of_homes_to_live_in
			render 'edit_petsitter_home_details'
		end

	end


	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	# ~~~~~~~~~~~~~~~~~~~~FIFTH STEP OF MULTISTEP FORM~~~~~~~~~~~~~~~~~~

	def edit_petsitter_charges_plus_calendar
		
		@petsitter = Petsitter.find( params[:id] )

	end

	def update_petsitter_charges_plus_calendar
		
	end


	# ------other private methods that can't be routed to directly----
	private

end
