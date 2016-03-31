module ApplicationHelper

	# -------USED THIS HELPERS IN  HEADER SECTION FOR NAVBAR STUFF---------
	def current_petsitter

		petsitterobjectview = Petsitter.find( session[:petsitter] )
		return petsitterobjectview
		
	end

	def current_petowner

		petownerobjectview = Petowner.find( session[:petowner] )
		return petownerobjectview
		
	end


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

			petsitter.pettypes.each do |petarray|

				a.push(petarray.type_name.pluralize)
				# 'post'.pluralize will become "posts"

			end

			string_to_return = a.join(" , ")

			return string_to_return = "Can care for: #{string_to_return}"

		end
		
	end

	

end
