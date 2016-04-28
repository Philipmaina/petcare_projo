# == Schema Information
#
# Table name: petsitters
#
#  id                                 :integer          not null, primary key
#  first_name                         :string
#  surname                            :string
#  other_names                        :string
#  date_of_birth                      :date
#  residential_area_id                :integer
#  personal_email                     :string
#  contact_line_one                   :string
#  contact_line_two                   :string
#  no_of_yrs_caring                   :integer
#  no_of_pets_owned                   :integer
#  type_of_home                       :string
#  presence_of_open_area_outside_home :boolean
#  work_situation                     :string
#  day_charges                        :integer          default(0)
#  night_charges                      :integer          default(0)
#  default_pic_file_name              :string
#  listing_name                       :string
#  profile_description                :text
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null
#  password_digest                    :string
#

class Petsitter < ActiveRecord::Base

  # ----------------------------images/uploader stuff--------------------------
  mount_uploader :default_pic_file_name , ThumbnailstuffUploader

  # ----------------attributes created----------------------
  attr_accessor :registration_step



  # ----RAILS GIVES METHODS AND VALIDATIONS FOR STORING PASSWORDS---

  has_secure_password
  
  # this line above uses the bcrypt ruby gem to do encryption of passwords for us. So usually it is commented out so we uncomment it 
  # adds validations like presence and uniqueness so we don't have to explicitely add them
  # this line also adds a pair of virtual attributes(password and password_confirmation)
  # -----------------------------------------------------------------
  


  # ---------------R/SHIPS-----------------
  belongs_to :residential_area

  has_many :junctionofpetsitterandpettypes
  has_many :junctionofservicesandpetsitters
  has_many :unavailabledates
  has_many :pettypes, through: :junctionofpetsitterandpettypes
  has_many :sittingservices , through: :junctionofservicesandpetsitters
  has_many :bookings
  has_many :notificationforpetsitters
  # ----------------------------------------

  # ~~~~~~~~~~~~~~~~~~~~~~VALIDATIONS~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # 1)Partial object validation since we are using a multistep form
  # --------------------conditional validations------------------------------

  # ________1) step 1 validations______________________________________
  # the validation at the end applies to all the attributes tacked on
  validates :first_name , :surname , :contact_line_one , :personal_email , :residential_area_id , presence: true , if: :basic_details?  # if basic_details? returns true then this validation will be done otherwise it won't

  # validation options are just added after the attribute name like message , if , allow_blank
  # sometimes one doesn't want to use the default error message that is given by Rails so you can create custom error messages .
  # the unless means if the field is blank don't bother running this validation
  validates_uniqueness_of :contact_line_one , :message => "chosen is already in use." , if: :basic_details? , unless: 'contact_line_one.blank?'

  validates_uniqueness_of :personal_email , :message => "chosen is already in use", if: :basic_details? , unless: 'personal_email.blank?'


  # ________2) step 2 validations_________________________________________
  validates_uniqueness_of :contact_line_two , :message => "entered is already in use. " , if: :personal_details?

  
  validates_uniqueness_of :listing_name , :message => "has been chosen by another user.Please choose another." , if: :personal_details?

  # this field in the form can be left blank but if user decides to write they might write something between 35 - 280 characters , we want it like this because this description is to be read by petowners and it will help them know petsitter better
  validates_length_of :profile_description , :minimum => 35 , :maximum => 280 , :allow_blank => true , :too_long => "Please summarize your description...it's just a bit too long" , :too_short => "Please write a little more about yourself...that's just a bit too short" , if: :personal_details?

   # _______3) step 3 validations________________________________________
   
   # validated no_of_yrs_caring and no_of_pets_owned frontend by putting a minimum option of 0 for both and for no_of_pets_owned a max of 20 - as seen in f.number_field for both attributes.

   # ______4) step 4 validations_________________________________________
   
   # since it's a dropdown list for type of home and a radio button group(converted to look like toggle buttons) we dont need validations.

   # _____5) step 5 validations__________________________________________
   
   # since i have a slider for the price and a popup calendar for choosing the dates unavailable- i have already frontend validated for now





# ~~~~~~~~~~~~~~~~~~~~~~~~METHODS~~~~~~~~~~~~~~~~~~~~~~~~~~
  def basic_details?
  	registration_step == "basic_predetails"
  end

  def personal_details?
    registration_step == "personal_details"
  end


  # Class level methods are methods that are called on a class and instance methods(object methods) are methods that are called on an instance of a class e.g .update
  # the method below is a class method and is why we precede with self
  # this array could have been easily placed in the controller but the controller shouldn't be the source of data or shouldnt care where the data comes from , it should ask the model for data 
  def self.all_work_situations_they_can_have
   return [ "Work from home" , "Working locally with off days" , "Student with flexible timetable" , "Retired" , "Stay at home parent/husband/wife"]
  end

  def self.all_types_of_homes_to_live_in
    return ["Apartment" , "Estate house" , "Standalone house"] 
  end

end
