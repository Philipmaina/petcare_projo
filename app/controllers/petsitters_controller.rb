# == Schema Information
#
# Table name: petsitters
#
#  id                                 :integer          not null, primary key
#  first_name                         :string
#  surname                            :string
#  other_names                        :string
#  date_of_birth                      :date
#  residential_area_id                :integer
#  personal_email                     :string
#  contact_line_one                   :string
#  contact_line_two                   :string
#  no_of_yrs_caring                   :integer
#  no_of_pets_owned                   :integer
#  type_of_home                       :string
#  presence_of_open_area_outside_home :boolean
#  work_situation                     :string
#  day_charges                        :integer          default(0)
#  night_charges                      :integer          default(0)
#  default_pic_file_name              :string
#  listing_name                       :string
#  profile_description                :text
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null
#  password_digest                    :string
#

class PetsittersController < ApplicationController

	# ~~~~~~~~~~~~~~FIRST STEP OF MULTISTEP FORM~~~~~~~~~~~~
	def new_basic_predetails
		@petsitter = Petsitter.new #object that form will bind to 
		
		# we could have put what is below directly in the view but the controller's job is supposed to be to ask data from the model and set it up for the views - the view should be completely decoupled from the model( the view should never know of the model's existence )
		@all_residential_areas_in_nairobi = ResidentialArea.all
	end

	def create_basic_predetails
	
		petsitter_first_step_params = params.require(:petsitter).permit( :first_name , :surname , :other_names , :contact_line_one , :personal_email , :residential_area_id , :password , :password_confirmation ) #prevents mass assignment

		@petsitter = Petsitter.new( petsitter_first_step_params )

		# --THIS WILL HELP US IN THE PARTIAL OBJECT VALIDATION WHILE SAVING--
		@petsitter.registration_step = "basic_predetails"

		if @petsitter.save

			# if you create an account with us which in our case involves bypassing the first step of our multistep form we want to automatically sign in you otherwise you would have to sign in as a separate step
			session[:petsitter] = @petsitter.id
			
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

		petsitter_first_step_params = params.require(:petsitter).permit( :first_name , :surname , :other_names , :contact_line_one , :personal_email , :residential_area_id , :password , :password_confirmation ) #prevents mass assignment

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
		@sittingservices = Sittingservice.all # wil allow petsitter to choose pet services he can be able to offer
		@allpettypesthatexist = Pettype.all # will allow petsitter to choose the pets he can care for
	end

	def update_petsitter_experience_and_skills_details
		
		@petsitter = Petsitter.find( params[:id] )

		# in this case i don't need a registration step because there is nothing to validate the partial object in the models - the validation is done frontend

		if params[:pets_that_you_can_care_for].present?
			# within the form i created checkboxes which look like toggle buttons and that allow multiple selection as do all checkboxes.

			# "pets_that_you_can_care_for"=>["1",
 			# "2"]
 			# the section above shows the request parameters when intercepted by fail
 			# the value is an array of ids of pettypes that we can look up to find objects in Pettype that match the pettypes

 			array_of_all_pets_sitter_can_care_for = params[:pets_that_you_can_care_for] 

 			array_of_all_pets_sitter_can_care_for.each do | pet_id_element_array|

 				pettype_object_from_db = Pettype.find(pet_id_element_array)

 				# below we create an object from parent object
 				object_to_store_in_junction_of_sitterandpettypes = @petsitter.junctionofpetsitterandpettypes.new

 				object_to_store_in_junction_of_sitterandpettypes.pettype = pettype_object_from_db 

 				object_to_store_in_junction_of_sitterandpettypes.save

 				
 			end
				
		end #endif


		if params[:pet_services_you_can_offer].present?

			# within the form i created the checkboxes that look like toggle buttons but not using f object coz there is no attribute of sittingservices that lives directly on @petsitter which was what the form was bound to it. The siitingservice would actual be one to many relation. NOTE TO FUTURE SELF: FIND A WAY TO MAKE THIS A ONE TO MANY FORM EVEN THOUGH THERE ARE OTHER FIELDS.
			# therefore i created normal checkboxes not bound to f object but that all have one name that is like an array as is needed- 'pet_services_you_can_offer[]' - this ends up being a key which one can see if you use the fail method and the value of this key is an array of chosen textboxes
			array_of_all_the_services_pet_sitter_can_do = params[:pet_services_you_can_offer]


			array_of_all_the_services_pet_sitter_can_do.each do | service |

				sitting_service_object_mapped_from_db = Sittingservice.find( service )
				# we are using the parent object to store the child record- therefore the petsitter id in the object will be filled with petsitter's id
				object_to_store_in_junctionsittinserviceandpetsittertbl_as_record =
				@petsitter.junctionofservicesandpetsitters.new

				# remember the belongs_to association of junctiontableoofservicesandpetsitters give us the method .sittingservice instead of having to write .sittingservice_id but one must pass an object to .sittingserviice
				object_to_store_in_junctionsittinserviceandpetsittertbl_as_record.sittingservice = sitting_service_object_mapped_from_db

				object_to_store_in_junctionsittinserviceandpetsittertbl_as_record.save
			end #end do

			
		end #end if 
		
		petsitter_third_step_params = params.require(:petsitter).permit( :work_situation , :no_of_yrs_caring , :no_of_pets_owned)

		if @petsitter.update( petsitter_third_step_params )
			redirect_to edit_petsitter_home_details_path( @petsitter.id )
		else

			# instance variables get killed off after an action runs so after edit_petsitter_experience_and_skills_details action we need to again declare this variable otherwise it will give an error of nil:Nil class when there are validation errors
			
			@all_work_situations = Petsitter.all_work_situations_they_can_have
			@sittingservices = Sittingservice.all
			@allpettypesthatexist = Pettype.all # will allow petsitter to choose the pets he can care for

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

		@petsitter = Petsitter.find( params[:id] )


		# Any Url parameters are automatically captured in a hash called params
		# If you check parameters by using fail trick one sees a key value pair of the name of the text field and the values chosen on the calendar which are the dates 
		# "unavailabledates"=>"2016-03-18,2016-03-19,2016-03-23,2016-03-24"
		# so we access the value which is a string with comma seperating the dates using the key(name of textfield)
		all_unavailable_dates_chosen = params[:unavailabledates] 


		# .split() divides strings into substrings based on a delimiter , returning that array
		all_unavailable_dates_chosen = all_unavailable_dates_chosen.split(',')

		for i in 0..( all_unavailable_dates_chosen.size - 1) do

			# this converts each substring to a date
			b = all_unavailable_dates_chosen[i].to_date

			# creating unavailabledates(child) record from parent object which is @petsitter(same as creating registration from event side)
			date_record_to_be_stored = @petsitter.unavailabledates.new( unavailable_dates_on: b )

			date_record_to_be_stored.save

		end

		value = params[:night_charges]
		@petsitter.update( night_charges: value )

		redirect_to pet_sitter_dashboard_path(@petsitter.id)
		
	end

	def dashboard
		
	end


	# ------other private methods that can't be routed to directly----
	private

end
