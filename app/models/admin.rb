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

  # the \S+ MEANS WE WANT A NON-WHITE SPACE CHARACTER ONE OR MORE OF THOSE .
  # the @ just means as is implied we need an @ symbol
  # the \. means we need a fullstop
  # THE REGEX FORMAT HAS FLAWS BECAUSE OF NUMBERS
  # NOTE TO FUTURE SELF: BY THE TIME YOU FULLY LEARN REGEX , RAILS VERSION 20 WILL HAVE BEEN SHIPPED OUT
  validates_format_of :personal_email , :with => /\S+@\S+\.\S+/ , :message => "format is invalid"  , unless: 'personal_email.blank?'
  # ---------------------------------------------------------------------------

  # ----------------------------------------------------------------------------
end
