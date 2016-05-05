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

class Sittingservice < ActiveRecord::Base

	# --------------------VALIDATIONS-----------------------

	validates :service_name , presence: true , uniqueness: true
	validates :place_offered , presence: true  





	# ------------------------------------------------------


	# --------------R/SHIPS----------------
	has_many :junctionofservicesandpetsitters
	has_many :petsitters , through: :junctionofservicesandpetsitters
	has_many :bookings
	# ---------------------------------------
end
