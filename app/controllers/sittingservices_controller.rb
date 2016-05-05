# == Schema Information
#
# Table name: sittingservices
#
#  id                  :integer          not null, primary key
#  service_name        :string
#  service_description :text
#  place_offered       :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class SittingservicesController < ApplicationController


	def index

		@all_sittingservices = Sittingservice.all
		
	end

	def create

		
		#  Parameters: {"utf8"=>"✓", "service_name"=>"dfdh", "place_offered"=>"jghjgh", "commit"=>"Add Sitting service"}

		@sittingservice_obj = Sittingservice.new
		@sittingservice_obj.service_name = params[:service_name]
		@sittingservice_obj.place_offered = params[:place_offered]

		@all_sittingservices = Sittingservice.all #this is for the table section - remember instance do not live on after an action runs so we have to create again

		if @sittingservice_obj.save
			
			flash.now[:notice] = "Awesome!! You've added #{@sittingservice_obj.service_name} to the list of sitting services"
			
		end

		respond_to do | format |

			format.js {

				render 'index'

			}	
		end
		
		
	end



	def destroy

		# {"_method"=>"delete", "id"=>"10"}
		Sittingservice.destroy( params[:id] )

		redirect_to sittingservices_path , notice: "!! You have successfuly deleted the pet type !!"
		
	end

	def edit
		
		# {"id"=>"5"}
		@sittingservice_obj = Sittingservice.find( params[:id] )
		
	end

	def update

		
		# {"utf8"=>"✓","_method"=>"patch","sittingservice"=>{"service_name"=>"das","place_offered"=>"dfdf"},"commit"=>"Update Changes","id"=>"5"}
		@sittingservice_obj = Sittingservice.find( params[:id] )

		@sittingservice_obj.service_name = params[:sittingservice][:service_name]
		@sittingservice_obj.place_offered = params[:sittingservice][:place_offered]

		if @sittingservice_obj.save

			redirect_to sittingservices_path , notice: " !! You've updated #{@sittingservice_obj.service_name} sitting service details  !! "
		else

			render :edit

		end

			
	end

end
