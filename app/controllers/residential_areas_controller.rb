# == Schema Information
#
# Table name: residential_areas
#
#  id               :integer          not null, primary key
#  name_of_location :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class ResidentialAreasController < ApplicationController

	def index

		@all_locations = ResidentialArea.all

		@residential_area_obj = ResidentialArea.new
		
	end

	# i avoided creating the new action by fiddling around with frontend - the add location button that drops down the form 

	def create

		@residential_area_obj = ResidentialArea.new
		@residential_area_obj.name_of_location = params[:name_of_location]

		@all_locations = ResidentialArea.all

		if @residential_area_obj.save
			
			flash.now[:notice] = "Awesome!! You've added #{@residential_area_obj.name_of_location} to the list of locations"
			
		end

		respond_to do | format |

			format.js {

				render 'index'

			}	
		end
		
		
	end



	def edit

		
		# Parameters: {"id"=>"3"}
		@residential_area_obj = ResidentialArea.find( params[:id] )
		
	end

	def update
		
		# {"utf8"=>"✓","_method"=>"patch","residential_area"=>{"name_of_location"=>"Runda1"},"commit"=>"Update Changes","id"=>"2"}
		@residential_area_obj = ResidentialArea.find( params[:id] )
		# we have to specify two keys to get to the value we want inside this hash within a hash
		@residential_area_obj.name_of_location =  params[:residential_area][:name_of_location] 

		if @residential_area_obj.save

			redirect_to residential_areas_path , notice: " !! You've updated #{@residential_area_obj.name_of_location} location details  !! "
		else
			render :edit
		end


		
	end


	def destroy

		# {"_method"=>"delete","id"=>"12"}
		ResidentialArea.destroy( params[:id] )

		redirect_to residential_areas_path , notice: "!! You have successfuly deleted the location !!"
		
	end






	

end
