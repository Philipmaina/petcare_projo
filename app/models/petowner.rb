# == Schema Information
#
# Table name: petowners
#
#  id                    :integer          not null, primary key
#  first_name            :string
#  surname               :string
#  other_names           :string
#  date_of_birth         :date
#  personal_email        :string
#  contact_line_one      :string
#  contact_line_two      :string
#  profile_pic_file_name :string
#  ResidentialArea_id    :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class Petowner < ActiveRecord::Base
  # -------------ADDED ATTRIBUTES WHICH AREN'T IN DB TABLE------------

  attr_accessor :registration_step # we create a new attribute 
  # remember we dont have to create and declare attributes for the fields in our table because rails does it for us behind the scenes

  # -----------R/SHIPS----------

  belongs_to :ResidentialArea
  has_many :pets


  # ----------------------------VALIDATIONS-----------------------------------
  # ---1)we want to carry out partial object validation - that is we want to validate attributes present at each step - when we want to save just part of an object for that step because we havent filled all its attributes

  # --------------------conditional validations------------------------------

  # ________1) step 1 validations__________________________________________
  validates :first_name , :surname , :contact_line_one , :personal_email , :ResidentialArea_id , presence: true , if: :basic_details? # if basic_details? returns true then this validation will be done otherwise it won't

  # -----create custom error messages--------------------------------

  # what the validation below means is check whether the contact_line_one entered is unique( i.e no one else has it in the records of db). Also this validation should only be applied if the basic_details? method yields true which is when registration_step = basic_predetails. Finally do this whole validation UNLESS .blank? returns true (which is when contact_line_one field is blank ) => this simply means dont run this validation if the field is blank coz then there is no point in checking uniqueness of something blank. This helps avoid having two errors when the contact_line_one field is blank 
  validates_uniqueness_of :contact_line_one , :message => "chosen is already in use." , if: :basic_details? , unless: 'contact_line_one.blank?'

  validates_uniqueness_of :personal_email , :message => "chosen already in use", if: :basic_details? , unless: 'personal_email.blank?'

  # _______2) step 2 validations_________________________________________

  validates_uniqueness_of :contact_line_two , :message => "entered is already in use." , if: :personal_details?


  # ---------------------------methods-----------------------------------------
  # method names with question marks at the end means that the method returns a boolean(a true or a false).
  def basic_details?
  	registration_step == "basic_predetails" # comparison operator yields true or false.
  end

  def personal_details?
 	  registration_step == "personal_details"
  end

end
