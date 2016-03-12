# == Schema Information
#
# Table name: junctionofpetsitterandpettypes
#
#  id           :integer          not null, primary key
#  pettype_id   :integer
#  petsitter_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Junctionofpetsitterandpettype < ActiveRecord::Base
  # ---------R/SHIPS-------------
  belongs_to :pettype
  belongs_to :petsitter
  # -----------------------------
end
