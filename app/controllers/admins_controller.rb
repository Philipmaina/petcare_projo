# == Schema Information
#
# Table name: admins
#
#  id                  :integer          not null, primary key
#  first_name          :string
#  surname             :string
#  residential_area_id :integer
#  personal_email      :string
#  contact_line_one    :string
#  contact_line_two    :string
#  position_in_company :string
#  password_digest     :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class AdminsController < ApplicationController

	# this is where the request will land when an admin wants to edit his/her own profile from dashboard
	def edit
		# {"id"=>"1"}
		@admin_user = Admin.find( params[:id] )
		@all_residential_areas_in_nairobi = ResidentialArea.all

	end

	def update
		@admin_user = Admin.find( params[:id] )

		admin_params = params.require(:admin).permit(:first_name , :surname , :contact_line_one , :personal_email , :residential_area_id , :password , :password_confirmation , :contact_line_two )
		if @admin_user.update( admin_params )
			redirect_to admin_dashboard_path(@admin_user) , notice: "Successfully updated your profile details"
		else
			render :edit
		end
		
	end


	def dashboard
		
		@admin_user = Admin.find( params[:id] )
	end


	# this is when you click on the horizontal navbar on statistical info
	def statistical_analysis


		# --------this fills the first part of the row showing total number of petowners
		@total_number_of_petowners = Petowner.all.count
		# --------------------------------------------------------------------


		# --------this info is to help populate the pie chart--------------
		karen_place = ResidentialArea.find_by( name_of_location: "Karen" )
		@number_of_petowners_in_karen = karen_place.petowners.count


		runda_place = ResidentialArea.find_by( name_of_location: "Runda" )
		@number_of_petowners_in_runda = runda_place.petowners.count


		lavington_place = ResidentialArea.find_by( name_of_location: "Lavington" )
		@number_of_petowners_in_lavington = lavington_place.petowners.count


		chiromo_place = ResidentialArea.find_by( name_of_location: "Chiromo" )
		@number_of_petowners_in_chiromo = chiromo_place.petowners.count
		# ---------------------------------------------------------------------




		# --------------this info is for populating the line graph----------

		# if say we are in april we want our graph to stop in april because we don't what will happen in the other months-maybe people could destroy their account so we avoid extrapolating-it is possible to do it for all months in the year and it will reach a point there will be a constant line as shown below but we avoid doing it for the simple reason that we dont know what will happen
		# therefore our horizontal axis will have only upto the month we are on in the current year - if we are in April we stop there

		# |
		# |
		# |    ~~~~~~~~~~~~~
		# |   /
		# |  /
		# | /
		# |/
		# |-----------------

		@string_of_all_months_upto_current_month = Array.new
		@all_petowners_within_months = Array.new


		# NOTE TO FUTURE SELF: AMAZING HOW SHORT THE CODE IS :) :)    
		for i in 1..Time.now.month do

			# Ruby Date class provides a constant array of month names. You can pass month number as index to Date::MONTHNAMES and will get month name as string
			@string_of_all_months_upto_current_month.push(Date::MONTHNAMES[i])

		    @all_petowners_within_months.push( Petowner.where( 'created_at <= ?' , Date.new(Date.today.year,i).end_of_month  ).count  )

		end
		# -------------------------------------------------------------------


	end






	# ---------THE NETHOD statistics_on_pet_owners IS EXACTLY THE SAME AS THE METHOD statistical_analysis , THE ONLY DIFF IS ONE IS REACHED FROM A COMPLETE RELOAD(REDIRECT) AND ANOTHER FROM AN AJAXIFIED FORM BEING SENT

	# this is when within statistical info you click the tab like arrow pet owners
	def statistics_on_pet_owners

		# ~~~~~~~~~~~~~THIS IS FOR POPULATING THE PIE CHART~~~~~~~~~~~~~

		@total_number_of_petowners = Petowner.all.count

		karen_place = ResidentialArea.find_by( name_of_location: "Karen" )
		@number_of_petowners_in_karen = karen_place.petowners.count


		runda_place = ResidentialArea.find_by( name_of_location: "Runda" )
		@number_of_petowners_in_runda = runda_place.petowners.count


		lavington_place = ResidentialArea.find_by( name_of_location: "Lavington" )
		@number_of_petowners_in_lavington = lavington_place.petowners.count


		chiromo_place = ResidentialArea.find_by( name_of_location: "Chiromo" )
		@number_of_petowners_in_chiromo = chiromo_place.petowners.count

		# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



		# ~~~~~~~~~~~THIS IS FOR POPULATING THE LINE CHART~~~~~~~~~~~~~~~~~~

		@string_of_all_months_upto_current_month = Array.new
		@all_petowners_within_months = Array.new


		# NOTE TO FUTURE SELF: AMAZING HOW SHORT THE CODE IS :) :)    
		for i in 1..Time.now.month do

			# Ruby Date class provides a constant array of month names. You can pass month number as index to Date::MONTHNAMES and will get month name as string
			@string_of_all_months_upto_current_month.push(Date::MONTHNAMES[i])

		    @all_petowners_within_months.push( Petowner.where( 'created_at <= ?' , Date.new(Date.today.year,i).end_of_month  ).count  )

		end
		# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


		# ~~AND BECAUSE WE REACH HERE FROM AN AJAXIFIED FORM BEING SENT~~
		respond_to do |format|

			format.js #this will fall through and render admins/statistics_on_pet_owners.js.erb

		end

			
	end
	# -----------------------------------------------------------------------


	# this is when within statistical info you click the tab like arrow pet sitters
	def statistics_on_pet_sitters

		# ~~~~~~~~~~~~~THIS IS FOR POPULATING THE PIE CHART~~~~~~~~~~~~~

		@total_number_of_petsitters = Petsitter.all.count

		karen_place = ResidentialArea.find_by( name_of_location: "Karen" )
		@number_of_petsitters_in_karen = karen_place.petsitters.count


		runda_place = ResidentialArea.find_by( name_of_location: "Runda" )
		@number_of_petsitters_in_runda = runda_place.petsitters.count


		lavington_place = ResidentialArea.find_by( name_of_location: "Lavington" )
		@number_of_petsitters_in_lavington = lavington_place.petsitters.count


		chiromo_place = ResidentialArea.find_by( name_of_location: "Chiromo" )
		@number_of_petsitters_in_chiromo = chiromo_place.petsitters.count

		# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



		# ~~~~~~~~~~~THIS IS FOR POPULATING THE LINE CHART~~~~~~~~~~~~~~~~~~

		@string_of_all_months_upto_current_month = Array.new
		@all_petsitters_within_months = Array.new


		# NOTE TO FUTURE SELF: AMAZING HOW SHORT THE CODE IS :) :)    
		for i in 1..Time.now.month do

			# Ruby Date class provides a constant array of month names. You can pass month number as index to Date::MONTHNAMES and will get month name as string
			@string_of_all_months_upto_current_month.push(Date::MONTHNAMES[i])

		    @all_petsitters_within_months.push( Petsitter.where( 'created_at <= ?' , Date.new(Date.today.year,i).end_of_month  ).count  )

		end
		# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


		# ~~AND BECAUSE WE REACH HERE FROM AN AJAXIFIED FORM BEING SENT~~
		respond_to do |format|

			format.js #this will fall through and render admins/statistics_on_pet_sitters.js.erb

		end

		
	end

	# this is when within statistical info you click the tab like arrow all on bookings
	def statistics_on_bookings
		
	end


end
