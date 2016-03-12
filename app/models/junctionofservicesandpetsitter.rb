# == Schema Information
#
# Table name: junctionofservicesandpetsitters
#
#  id                :integer          not null, primary key
#  petsitter_id      :integer
#  sittingservice_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Junctionofservicesandpetsitter < ActiveRecord::Base




  # ~~~~~~~~~R/SHIPS~~~~~~~~~
  belongs_to :petsitter
  belongs_to :sittingservice
  # ~~~~~~~~~~~~~~~~~~~~~~~~~
end
