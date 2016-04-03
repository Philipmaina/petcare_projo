class Booking < ActiveRecord::Base
  belongs_to :petowner
  belongs_to :petsitter
  belongs_to :residential_area
  belongs_to :sittingservice
end
