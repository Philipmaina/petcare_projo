# == Schema Information
#
# Table name: pets
#
#  id                        :integer          not null, primary key
#  pettype_id                :integer
#  petowner_id               :integer
#  pet_name                  :string
#  years_pet_lived           :integer
#  months_pet_lived          :integer
#  gender                    :string
#  breed                     :string
#  size_of_pet               :string
#  default_pet_pic_file_name :string
#  alternative_pic_file_name :string
#  care_handle_instructions  :text
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

class PetsController < ApplicationController



	# ______________________________________________________________________


	# we give before_action a method to run before all the actions
	# so we give except where we put actions that this method should not run before - easier to invert
	# we put require_signin method where it'll be accessed by all other controllers coz we might want to use it in another controller , hence we put it in ApplicationController
	before_action :require_petowner_signin , only: [:index , :edit , :update , :destroy]

	# order here matters - we want to check the correct petsitter only after we've checked whether a petsitter is even signed in
	# stuff is run in a top down order
	before_action :require_correct_petowner , only: [ :index , :edit , :update , :destroy ]

	

	# ________________________________________________________________________

	def index
		# keep in mind petowner has/owns many pets
		@petowner_who_owns_the_pets = Petowner.find( params[:petowner_id] )
		@pets = @petowner_who_owns_the_pets.pets #get an array of pets objects - we are scoping our query to a particular petowner's pets
		
	end

	def edit

		@petowner_who_owns_the_pets = Petowner.find( params[:petowner_id] )
		@pet_to_be_edited = Pet.find( params[:id] )
		@all_pets_in_system = Pettype.all
		
	end

	def update

		
		@petowner_who_owns_the_pets = Petowner.find( params[:petowner_id] )

		@pet_to_be_edited = Pet.find( params[:id] )

		pet_params = params.require(:pet).permit( :pet_name , :years_pet_lived , :gender , :pettype_id)

		if @pet_to_be_edited.update( pet_params )

			flash[:notice] = "Successfully updated #{@pet_to_be_edited.pet_name.possessive} details "
			redirect_to petowner_pets_path(@petowner_who_owns_the_pets.id) 

		else

			render 'edit'

		end


		
	end

	def destroy

		@petowner_who_owns_the_pets = Petowner.find( params[:petowner_id] )

		@pet = Pet.find( params[:id] )
		flash[:notice] = "Successfully deleted pet #{@pet.pet_name} from system !!!" # i set up the flash here while the @pet object still is there - dont want to set it after destroy because then i won't have anything

		@pet.destroy


		redirect_to petowner_pets_path(@petowner_who_owns_the_pets.id) 

	end








	private

		def require_correct_petowner

	      # checked if signed in petowner is the same as the one whose details are currently being updated,edited or deleted.

	      @petowner = Petowner.find( params[:petowner_id] )

	      # do something else blahblah...
	      unless current_petowner == @petowner
	        redirect_to root_path
	      end
	      
	    end

end
