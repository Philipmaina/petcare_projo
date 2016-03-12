# == Schema Information
#
# Table name: petsitters
#
#  id                                 :integer          not null, primary key
#  first_name                         :string
#  surname                            :string
#  other_names                        :string
#  date_of_birth                      :date
#  ResidentialArea_id                 :integer
#  personal_email                     :string
#  contact_no_one                     :string
#  contact_no_two                     :string
#  no_of_yrs_caring                   :integer
#  no_of_pets_owned                   :integer
#  type_of_home                       :string
#  presence_of_open_area_outside_home :boolean
#  work_situation                     :string
#  day_charges                        :integer
#  night_charges                      :integer
#  default_pic_file_name              :string
#  listing_name                       :string
#  profile_description                :text
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null
#

require 'test_helper'

class PetsittersControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
end
