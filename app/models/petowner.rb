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
#  residential_area_id   :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  password_digest       :string
#

class Petowner < ActiveRecord::Base

  mount_uploader :profile_pic_file_name, ThumbnailstuffUploader
  # -------------ADDED ATTRIBUTES WHICH AREN'T IN DB TABLE------------

  attr_accessor :registration_step # we create a new attribute 
  # remember we dont have to create and declare attributes for the fields in our table because rails does it for us behind the scenes


  # ----RAILS GIVES METHODS AND VALIDATIONS FOR STORING PASSWORDS---

  has_secure_password
  
  # this line above uses the bcrypt ruby gem to do encryption of passwords for us. So usually it is commented out so we uncomment it 
  # adds validations like presence and uniqueness so we don't have to explicitely add them
  # this line also adds a pair of virtual attributes(password and password_confirmation)
  # -----------------------------------------------------------------


  
  # -----------R/SHIPS----------

  belongs_to :residential_area
  has_many :pets
  has_many :bookings
  has_many :notificationforpetowners


  # ----------------------------VALIDATIONS-----------------------------------
  # ---1)we want to carry out partial object validation - that is we want to validate attributes present at each step - when we want to save just part of an object for that step because we havent filled all its attributes

  # --------------------conditional validations------------------------------

  # ________1) step 1 validations__________________________________________
  validates :first_name , :surname , :contact_line_one , :personal_email , :residential_area_id , presence: true , if: :basic_details? # if basic_details? returns true then this validation will be done otherwise it won't

  # -----create custom error messages--------------------------------

  # what the validation below means is check whether the contact_line_one entered is unique( i.e no one else has it in the records of db). Also this validation should only be applied if the basic_details? method yields true which is when registration_step = basic_predetails. Finally do this whole validation UNLESS .blank? returns true (which is when contact_line_one field is blank ) => this simply means dont run this validation if the field is blank coz then there is no point in checking uniqueness of something blank. This helps avoid having two errors when the contact_line_one field is blank 
  validates_uniqueness_of :contact_line_one , :message => "chosen is already in use." , if: :basic_details? , unless: 'contact_line_one.blank?'

  validates_uniqueness_of :personal_email , :message => "chosen already in use", if: :basic_details? , unless: 'personal_email.blank?'

  # the \S+ MEANS WE WANT A NON-WHITE SPACE CHARACTER ONE OR MORE OF THOSE .
  # the @ just means as is implied we need an @ symbol
  # the \. means we need a fullstop
  # THE REGEX FORMAT HAS FLAWS BECAUSE OF NUMBERS
  # NOTE TO FUTURE SELF: BY THE TIME YOU FULLY LEARN REGEX , RAILS VERSION 20 WILL HAVE BEEN SHIPPED OUT
  validates_format_of :personal_email , :with => /\S+@\S+\.\S+/ , :message => "format is invalid" , if: :basic_details? , unless: 'personal_email.blank?'

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # \A[a-zA-Z]+([a-zA-Z]|\d)*@[a-z]+\.[a-z]+\z
  # \A this means the start of the string - where your email starts 
  # so i want to have the first portion of the email to have only letters and digits and no weird symbols 
  # also i dont want to start with numbers , if numbers should appear they shoulld be huko katikati si mwanzo
  # a-zA-Z]+ - this means i want letters within the range of a-z or capital A-Z and i want one or more of those letters - why we start out with this is because we are considering starting with atleast a letter before numbers start appearing
  # ([a-zA-Z]|\d)* - this means after either a letter/letters are read from above case, we can allow for either a letter or a digit to be read ZERO OR MORE OF THOSE(*)
  # @ - @ SYMBOL SHOULD APPEAR
  # [a-z]+ - then after the @ symbol, we can have one or more letters(in this case only letters no digits )
  # \. - this means we expect a dot , we have to escape with \ because . alone in regex means any any single character and thats not what we want
  # [a-z]+\z - this means that you can finally have letters a-z as many of them then end string 
  # NOTE THIS TAKES CARE OF .com or .net .gov BUT NOT .co.uk
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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
