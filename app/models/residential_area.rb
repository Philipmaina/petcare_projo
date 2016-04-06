# == Schema Information
#
# Table name: residential_areas
#
#  id               :integer          not null, primary key
#  name_of_location :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class ResidentialArea < ActiveRecord::Base
	# ------------------VALIDATIONS----------------------







	# -----------------------------------------------------


	# -----RELATIONSHIPS WITH OTHER TABLES/MODELS----------
	has_many :petowners
	has_many :petsitters
	has_many :bookings
	# -----------------------------------------------------
end
