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


			"PENDING CHARGE"

		else
			# we can use built in helpers within our custom helpers
			number_to_currency( petsitter.night_charges , unit: "KES " , precision: 0 )
		end
	
	end

	

end
