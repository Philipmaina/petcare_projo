module ApplicationHelper

	# -------USED THIS HELPERS IN  HEADER SECTION FOR NAVBAR STUFF---------
	# NOTE: WE MOVED THESE TWO HELPERS TO APP CONTROLLER BECAUSE WE NEED TO USE IT IN BOTH THE VIEWS AND CONTROLLER, AND HELPER METHODS AREN'T ACCESSIBLE IN CONTROLLERS
	
	# def current_petsitter

	# 	petsitterobjectview = Petsitter.find_by(id: session[:petsitter] )
	# 	return petsitterobjectview
		
	# end

	# def current_petowner

	# 	petownerobjectview = Petowner.find_by(id: session[:petowner] )
	# 	return petownerobjectview
		
	# end


	# -----USED THESE HELPERS IN SEARCH QUERY PAGE FOR SHOWING PETSITTERS---

	# this helps avod putting too much ruby conditionals in my search page view and allows for reusability elsewhere in another view
	# our custom helper accepts a petsitter object
	# this method will either return that string in first if statement or whatever number_to_currency generates
	def custom_price_rate(petsitter)

		# remember i run a migration to put default values of night charges and day charges to 0 for every petsitter created, so at that point they didnt really get to edit that price
		if petsitter.night_charges == 0

			# if we dont do that it prints the span tag as though it was text. Rails escapes the tags as a safe measure but we need it to be shown 
			"<span style='font-size: 11px ;'> PENDING CHARGE </span>".html_safe

		else
			# we can use built in helpers within our custom helpers
			number_to_currency( petsitter.night_charges , unit: "KES " , precision: 0 )
		end
	
	end


	def custom_prof_descr(petsitter)

		if petsitter.profile_description.blank?

			# this will be the default text shown if your profile description is blank
			truncate("I will care for your adorable pet in a loving way." , length: 60 , separator: ' ' )
		else

			truncate( petsitter.profile_description , length: 65 , separator: ' ' )
			
		end
		
	end


	def custom_listing_name(petsitter)

		if petsitter.listing_name.blank?

			# default listing name if petsitter has none
			"Awesome petsitter"


		else

			petsitter.listing_name
	
		end
		
	end

	def custom_petscare_for(petsitter)

		if petsitter.pettypes.blank?

			"Yet to declare the pets that I can care for"

		else

			a = Array.new #this is store the names of the pets themselves not whole object

			# petsitter.pettypes returns an array of pettypes objects if any 
			# then we loop through getting each object
			# we store the pettype name in the array
			# later we'll call .join() passing in a parameter that creates a string separating the element values by the parameter
			# ["cat" , "dog" , "horse"].join(" , ")
 			# "cat , dog , horse"
 			# we want it to read Can care for: dogs , horses , pets......

			petsitter.pettypes.each do |petelement|

				a.push(petelement.type_name.pluralize)
				# 'post'.pluralize will become "posts"

			end

			string_to_return = a.join(" , ")

			return string_to_return = "Can care for: #{string_to_return}"

		end
		
	end

	# one would think that these next set of helpers aren't needed but what if you do step 1 and want to skip the rest of the steps of sign up - your type of house will be nil - so wont necessarily have a value though theoretically if you got to Step 4 it would take the first value in the dropdown list

	# :contact_line_two => nil,
    # :no_of_yrs_caring => nil,
    # :no_of_pets_owned => nil,
    # :type_of_home => nil,
    # :presence_of_open_area_outside_home => nil,
    # :work_situation => nil,
    # :default_pic_file_name => nil,
    # :listing_name => nil,
    # :profile_description => nil,

    # THESE NEXT HELPERS WILL BE USED IN SHOW_PAGE_FOR_QUERRIED_PETSITTER
	def custom_type_of_home(petsitter)

		if petsitter.type_of_home.blank?

			"?"

		else

			return petsitter.type_of_home

		end

	end

	def custom_presence_of_open_area(petsitter)

		if petsitter.presence_of_open_area_outside_home.blank?

			"?"
		else

			return petsitter.presence_of_open_area_outside_home
			
		end
		
	end

	def custom_work_situation(petsitter)

		if petsitter.work_situation.blank?

			"?"

		else

			return petsitter.work_situation

		end
		
	end

	def custom_no_of_yrs_caring(petsitter)

		if petsitter.no_of_yrs_caring.blank?

			"?"

		else

			return petsitter.no_of_yrs_caring

		end
		
	end

	def custom_no_of_pets_owned(petsitter)

		if petsitter.no_of_pets_owned.blank?

			"?"

		else

			return petsitter.no_of_pets_owned
			
		end
	
	end

	def custom_services_offered(petsitter)

		if petsitter.sittingservices.blank?

			"Yet to declare sitting services"
			
		else

			a = Array.new #this is store the names of the petsservices themselves not whole object

			# petsitter.sittingservices returns an array of sittingservices objects if any 
			# then we loop through getting each object
			# we store the sittingservice name in the array
			# later we'll call .join() passing in a parameter that creates a string separating the element values by the parameter
			# ["Normal boarding" , "Daycare" , "In home boarding" ].join(" , ")
 			# "Normal boarding , Daycare , In home boarding"
 			# we want it to read Sitting services: Normal boarding , daycare...

			petsitter.sittingservices.each do |serviceelement|

				a.push(serviceelement.service_name)
			end


			string_to_return = a.join(" , ")

			return string_to_return = " #{string_to_return}"

		end


		
	
	end


	def customize_thumbnail_pic(petsitter)

		if petsitter.default_pic_file_name.blank?

			"<i class='fa fa-user fa-5x' ></i> ".html_safe

		else

			 image_tag(@petsitter_querried.default_pic_file_name.thumb , :style => "border-radius: 50% ;padding-top: 5px;") 

		end
	end



# --------THIS HELPS IN THE SHOW PAGE FOR QUERRIED PETSITTER---------------
# --------IT HELPS DISABLE DATES WHEN THE PETSITTER IS UNAVAILABLE---------

	def ruby_array_to_javascript_dates_multidates_picker(petsitter)

		ruby_array_of_dates = Array.new

		# firstly for the current petsitter we get the array of dates he/she is unavailable for in ruby
		petsitter.unavailabledates.each do |unavailabledate_object|
			ruby_array_of_dates.push(unavailabledate_object.unavailable_dates_on)
		end

		# addDisabledDates: [today.setDate(1), today.setDate(3)]
		# we want to do the same but base our dates from the ruby array above
		if ruby_array_of_dates.respond_to?(:map)


			# The map method takes an enumerable object and a block, and runs the block for each element, outputting each returned value from the block (the original object is unchanged unless you use map!)
			# a = [1,2,3]

			# a.map { |n| n * n } #=> [1, 4, 9]
			# but a is still [1,2,3]

			return ruby_array_of_dates.map{ |eachdate| 

				"new Date(#{eachdate.year}, #{eachdate.month - 1}, #{eachdate.day})"

			}
			
		end

		# at the end we get 
		
		# [new Date(2016, 2, 24), new Date(2016, 2, 25), new Date(2016, 3, 11), new Date(2016, 3, 12), new Date(2016, 3, 14)]

		# addDisabledDates: [new Date(2016, 2, 24), new Date(2016, 2, 25), new Date(2016, 3, 11), new Date(2016, 3, 12), new Date(2016, 3, 14)]

		
	end

	def format_dates_for_js(petsitter)

		# gsub - Returns a copy of str with the all occurrences of pattern substituted for the second argument. 

		# "[\"new Date(2016, 2, 24)\", \"new Date(2016, 2, 25)\", \"new Date(2016, 3, 11)\", \"new Date(2016, 3, 12)\", \"new Date(2016, 3, 14)\"]"

		# so gsub(" \" " , "") means everywhere there is a backslash followed by a quotation mark replace with nothing(space)

		# "[new Date(2016, 2, 24), new Date(2016, 2, 25), new Date(2016, 3, 11), new Date(2016, 3, 12), new Date(2016, 3, 14)]"

		ruby_array_to_javascript_dates_multidates_picker(petsitter).to_s.gsub("\"", "").html_safe
	
	end

end
