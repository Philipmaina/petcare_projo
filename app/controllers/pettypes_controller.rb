# == Schema Information
#
# Table name: pettypes
#
#  id         :integer          not null, primary key
#  type_name  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PettypesController < ApplicationController

	def index

		@all_pettypes = Pettype.all


	end

	# i avoided creating the new action by fiddling around with frontend - the add location button that drops down the form 
	def create

		#  Parameters: {"utf8"=>"✓", "type_name"=>"ngoro", "commit"=>"Add Pet type"}

		@pettype_obj = Pettype.new
		@pettype_obj.type_name = params[:type_name]

		@all_pettypes = Pettype.all #this is for the table section - remember instance do not live on after an action runs so we have to create again

		if @pettype_obj.save
			
			flash.now[:notice] = "Awesome!! You've added #{@pettype_obj.type_name} to the list of pet types"
			
		end

		respond_to do | format |

			format.js {

				render 'index'

			}	
		end
		


		
	end


	def edit
		
		# Parameters: {"id"=>"3"}
		@pettype_obj = Pettype.find( params[:id] )
		
	end

	def update

		

		# {"utf8"=>"✓","_method"=>"patch","pettype"=>{"type_name"=>"hr4"},"commit"=>"Update Changes","id"=>"11"}

		@pettype_obj = Pettype.find( params[:id] )
		# we have to specify two keys to get to the value we want inside this hash within a hash
		@pettype_obj.type_name =  params[:pettype][:type_name] 

		if @pettype_obj.save

			redirect_to pettypes_path , notice: " !! You've updated #{@pettype_obj.type_name} pet type details  !! "
		else
			render :edit
		end
		
	end



	def destroy


		# {"_method"=>"delete", "id"=>"10"}
		Pettype.destroy( params[:id] )

		redirect_to pettypes_path , notice: "!! You have successfuly deleted the pet type !!"

		
	end

end
