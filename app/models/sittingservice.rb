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
	# --------------R/SHIPS----------------
	has_many :junctionofservicesandpetsitters
	has_many :petsitters , through: :junctionofservicesandpetsitters
	has_many :bookings
	# ---------------------------------------
end
