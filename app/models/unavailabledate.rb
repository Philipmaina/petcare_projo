# == Schema Information
#
# Table name: unavailabledates
#
#  id                   :integer          not null, primary key
#  petsitter_id         :integer
#  unavailable_dates_on :date
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class Unavailabledate < ActiveRecord::Base




  # ~~~~~~~r/ships~~~~~
  belongs_to :petsitter
  # ~~~~~~~~~~~~~~~~~~~~
end
