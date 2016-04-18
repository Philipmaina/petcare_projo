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

		@total_number_of_petowners = Petowner.all.count

		karen_place = ResidentialArea.find_by( name_of_location: "Karen" )
		@number_of_petowners_in_karen = karen_place.petowners.count


		runda_place = ResidentialArea.find_by( name_of_location: "Runda" )
		@number_of_petowners_in_runda = runda_place.petowners.count


		lavington_place = ResidentialArea.find_by( name_of_location: "Lavington" )
		@number_of_petowners_in_lavington = lavington_place.petowners.count


		chiromo_place = ResidentialArea.find_by( name_of_location: "Chiromo" )
		@number_of_petowners_in_chiromo = chiromo_place.petowners.count

	end






	# this is when within statistical info you click the tab like arrow pet owners
	def statistics_on_pet_owners


		karen_place = ResidentialArea.find_by( name_of_location: "Karen" )
		@number_of_petowners_in_karen = karen_place.petowners.count


		runda_place = ResidentialArea.find_by( name_of_location: "Runda" )
		@number_of_petowners_in_runda = runda_place.petowners.count


		lavington_place = ResidentialArea.find_by( name_of_location: "Lavington" )
		@number_of_petowners_in_lavington = lavington_place.petowners.count


		chiromo_place = ResidentialArea.find_by( name_of_location: "Chiromo" )
		@number_of_petowners_in_chiromo = chiromo_place.petowners.count

			
	end


	# this is when within statistical info you click the tab like arrow pet sitters
	def statistics_on_pet_sitters
		
	end

	# this is when within statistical info you click the tab like arrow all on bookings
	def statistics_on_bookings
		
	end


end
