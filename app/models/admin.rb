# == Schema Information
#
# Table name: admins
#
#  id                  :integer          not null, primary key
#  first_name          :string
#  surname             :string
#  residential_area_id :integer
#  personal_email      :string
#  contact_line_one    :string
#  contact_line_two    :string
#  position_in_company :string
#  password_digest     :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Admin < ActiveRecord::Base


  # ------------r/ships-----------
  belongs_to :residential_area
  # ------------------------------



  # -------------------------------VALIDATIONS---------------------------------

  has_secure_password #this line gives us validation of passowrd like ensuring password isn't blank or that password and password_confirmation match

  # -----------------------basic validations----------------------------------
  validates :first_name , :surname , :contact_line_one , :personal_email , :residential_area_id , :contact_line_two  , presence: true
  validates :personal_email , :contact_line_one , :contact_line_two , uniqueness: true
  # ---------------------------------------------------------------------------

  # ----------------------------------------------------------------------------
end
