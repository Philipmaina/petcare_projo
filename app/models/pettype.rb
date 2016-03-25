# == Schema Information
#
# Table name: pettypes
#
#  id         :integer          not null, primary key
#  type_name  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Pettype < ActiveRecord::Base

	# --------------VALIDATIONS------------------






	# ----------------RELATIONSHIPS--------------
	has_many :pets
	has_many :junctionofpetsitterandpettypes
	has_many :petsitters , through: :junctionofpetsitterandpettypes
	# -------------------------------------------
end
