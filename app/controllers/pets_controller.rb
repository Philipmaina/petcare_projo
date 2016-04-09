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

	def index
		# keep in mind petowner has/owns many pets
		@petowner_who_owns_the_pets = Petowner.find( params[:petowner_id])
		@pets = @petowner_who_owns_the_pets.pets #get an array of pets objects - we are scoping our query to a particular petowner's pets
		
	end
end
