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

		# ---CHECK EXPLANATION OF CODE BELOW IN STATISTICS PETSITTER ACTION---
		@array_to_send_to_values_of_pie_chart = [] # because we need an array of like js objects.
		ResidentialArea.all.each do | residential_area_obj|

	
			hash_to_include_as_element = {}

			hash_to_include_as_element[:label] = residential_area_obj.name_of_location
			hash_to_include_as_element[:value] = residential_area_obj.petowners.count
			hash_to_include_as_element[:color] = "#" + SecureRandom.hex(3) 

			@array_to_send_to_values_of_pie_chart.push(hash_to_include_as_element.to_json.gsub(/\"/, '\'') )
			
		end

	
		@array_to_send_to_values_of_pie_chart = @array_to_send_to_values_of_pie_chart.to_s.gsub('"' , '' )


		# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



		



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

			# this checks for all accounts which were created on or before the end of the month that the loop is on(remember the loop is cycling through from month 1 to current month)
		    @all_petowners_within_months.push( Petowner.where( 'created_at <= ?' , Date.new(Date.today.year,i).end_of_month  ).count  )

		end
		# -------------------------------------------------------------------


	end






	# ---------THE NETHOD statistics_on_pet_owners IS EXACTLY THE SAME AS THE METHOD statistical_analysis , THE ONLY DIFF IS ONE IS REACHED FROM A COMPLETE RELOAD(REDIRECT) AND ANOTHER FROM AN AJAXIFIED FORM BEING SENT

	# this is when within statistical info you click the tab like arrow pet owners
	def statistics_on_pet_owners

		@total_number_of_petowners = Petowner.all.count


		# ---CHECK EXPLANATION OF CODE BELOW IN STATISTICS PETSITTER ACTION---
		@array_to_send_to_values_of_pie_chart = [] # because we need an array of like js objects.
		ResidentialArea.all.each do | residential_area_obj|

	
			hash_to_include_as_element = {}

			hash_to_include_as_element[:label] = residential_area_obj.name_of_location
			hash_to_include_as_element[:value] = residential_area_obj.petowners.count
			hash_to_include_as_element[:color] = "#" + SecureRandom.hex(3) 

			@array_to_send_to_values_of_pie_chart.push(hash_to_include_as_element.to_json.gsub(/\"/, '\'') )
			
		end

	
		@array_to_send_to_values_of_pie_chart = @array_to_send_to_values_of_pie_chart.to_s.gsub('"' , '' )


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
		@total_number_of_petsitters = Petsitter.all.count
		

		# ~~~~~~~~~~~~~~THIS IS FOR POPULATING THE PIE CHART~~~~~~~~~~~~~



		# From the Chart.js docs: For a pie chart, you must pass in array of objects with a value and an optional color property.the value attribute should be a number while the color property should be a string.
		# -------we want something that lloks like this because that is what Chart.js accepts as data to populate its pie chart - simply an array of javascript objects

		# [
		    # {
		        # value: 5,
		        # color:"#F7464A",
		        # label: "Karen"
		    # },
		    # {
		        # value: 7 ,
		        # color: "#46BFBD",
		        # label: "Runda"
		    # }
	    # ]
	# ------ or something like below(this is what we will generate) ----------
		# [
		    # {
		        # 'value': 5,
		        # 'color':'#F7464A',
		        # 'label': 'Karen'
		    # },
		    # {
		        # 'value': 7 ,
		        # 'color': '#46BFBD',
		        # 'label': 'Runda'
		    # }
		# ]

		# --xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
		# we want this data to be made dynamically retrieved instead of hardcoding the names and checking values as below,because here if the residential areas increase in number we have to come back to the code and add the new place which is annoying in the long run
		# 	var data = [
		#     {
		#         "value": '<%=  number_of_users_in_karen %>',
		#         "color":"#F7464A",
		#         highlight: "#FF5A5E",
		#         label: "Karen"
		#     },
		#     {
		#         value: '<%= number_of_users_in_runda %>' ,
		#         color: "#46BFBD",
		#         highlight: "#5AD3D1",
		#         label: "Runda"
		#     }
		# ]
		# -----xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

		@array_to_send_to_values_of_pie_chart = [] # because we need an array of like js objects.

		# the code below is what makes it dynamic because it does for all areas in db even if a new is added.
		ResidentialArea.all.each do | residential_area_obj|

			# we will create a hash then later convert it to something looking like a json object
			hash_to_include_as_element = {}

			hash_to_include_as_element[:label] = residential_area_obj.name_of_location
			hash_to_include_as_element[:value] = residential_area_obj.petsitters.count
			hash_to_include_as_element[:color] = "#" + SecureRandom.hex(3) #SecureRandom.hex generates a random hexadecimal string and the argument n means the length of that string is twice that of n so like ours will be 6.each character in that string can range from 0-9-a-f 

			# this is where we make that hash appear like a json object only there will be double quotes encapsulating the json like object
			@array_to_send_to_values_of_pie_chart.push(hash_to_include_as_element.to_json.gsub(/\"/, '\'') )
			
		end

		# this is what the array will appear like 
		# [
		#     "{'label':'Karen','value':4,'color':'#177cb9'}",
		#     "{'label':'Runda','value':1,'color':'#2d223c'}",
		#     "{'label':'Lavington','value':0,'color':'#9e05d1'}",
		#     "{'label':'Chiromo','value':1,'color':'#cc905d'}"
		# ]
		# so all we have to do now is to chuck the double quotes surrounding {}
		@array_to_send_to_values_of_pie_chart = @array_to_send_to_values_of_pie_chart.to_s.gsub('"' , '' )


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

		# ~~~~~~~~~~~~THIS IS FOR THE TABLE OF BOOKINGS~~~~~~~~~~~~~~~~~~~~
		@all_booking_requests = Booking.all.count #all booking requests whether successful or unsuccessful

		@completed_pet_stays = Booking.where('end_date < ? AND petsitter_acceptance_confirmation = ? ' , Time.now.to_date , true).count

		@ongoing_bookings =  Booking.where('start_date <= ? AND end_date >= ? AND petsitter_acceptance_confirmation = ? ' , Time.now.to_date , Time.now.to_date , true).count

		# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


		# ~~~~~~~~~~~~~~~~~THIS IS FOR THE FIRST PIE CHART~~~~~~~~~~~~~~~~~~~~~
		@count_petowners_who_have_requested = 0
		@count_petowners_who_havent_requested = 0
		 
		Petowner.all.each do |petowner_object|

		    if petowner_object.bookings.present?
		       @count_petowners_who_have_requested += 1
		    else
		       @count_petowners_who_havent_requested += 1
		    end

		end
		# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


		# ~~~~~~~~~~~~~THIS IS FOR THE SECOND PIE CHART~~~~~~~~~~~~~~~~~~~~~~~
		@count_petsitters_who_have_requested = 0
		@count_petsitters_who_havent_requested = 0
		 
		Petsitter.all.each do |petsitter_object|

		    if petsitter_object.bookings.present?
		       @count_petsitters_who_have_requested += 1
		    else
		       @count_petsitters_who_havent_requested += 1
		    end

		end

		# ~~AND BECAUSE WE REACH HERE FROM AN AJAXIFIED FORM BEING SENT~~
		respond_to do |format|

			format.js #this will fall through and render admins/statistics_on_bookings.js.erb

		end


		
	end


	# this is to allow the admin to be presented with stuff they can change like residential_areas,pets we can care for
	def add_edit_stuff
		
	end


end
