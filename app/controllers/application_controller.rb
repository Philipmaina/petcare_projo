class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception



  # SINCE YOU CAN'T BYPASS THE CONTROLLER AND GO STRAIGHT TO THE VIEW WHEN DEFINING ROUTES - IT'S A VIOLATION AGAINST MVC PATTERN, I TEND TO USE THIS CONTROLLER AS ROUTES FOR PAGES THAT FALL OUTSIDE A SPECIFIC RESOURCE
  
  def index
  	
  end

  def page_for_choosing_type_of_registration
  	
  end

  def search_main_page

    # we could have put what is below directly in the view but the controller's job is supposed to be to ask data from the model and set it up for the views - the view should be completely decoupled from the model( the view should never know of the model's existence )
    @all_residential_areas_in_nairobi = ResidentialArea.all
    @allpets = Pettype.all
    @sittingservicesoffered = Sittingservice.all

    render 'search_page_for_petowners'
    
  end

  def find_all_petsitters_that_match_query
    fail

    # HOLD ON THIS WILL BE SOME KINDA LONG CODE THAT NEEDS UNDERSTANDING 
    # NOTE TO FUTURE SELF : READ ON LAMBDAS AND PROCS 

    # So my approach to this is create an array of petsitter for each criterion e. we have an array of petsitter objects that meet the criteria of the pet service specified , then we have an array of petsitter objects that meet the criteria of being available between the pickup date and dropoff date , then we have another array of petsitter objects that meet the criterion of pets that the user(petowner) has chosen to be cared for - so which petsitters can care for either one or many of the pets specified(OR)......BLAH BLAH BLAH

    # _____1) Create array of petsitters that care for the pets specified______

    # Reason first of why to bring even a petsitter who just cares for one of the pets specified(OR) and not enforce that the petsitter must care for all(AND) is because it is hard to find a sitter say who can take care of a dog, a parrot and a horse. So the petowner can just be presented with the petsitters who can care for one or the other AND THE PETOWNER CAN MAKE MANY DIFFERENT BOOKINGS - maybe his dog will be cared for by this petsitter 1 then his horse will be cared for by petsitter 2 - ESSENTIALLY IT IS NOT IDEAL BECAUSE YOU WOULD RATHER KNOW THAT ALL YOUR PETS ARE BEING CARED FOR BY ONE PERSON RATHER THAN BY MANY DIFFERENT PEOPLE COZ IT'S HARDER TO TRACK ALL YOUR PET'S PROGRESS DURING YOUR PERIOD AWAY BUT IT IS A DISADVANTAGE TO HAVE AN OCUURRENCE WHERE A MESSAGE IS DISPLAYED SAYING NO PETSITTERS CAN CARE FOR YOUR PETS - SO ITS JUST  BETTER TO AT LEAST PRESENT THEM WITH OPTIONS EVEN THOUGH THEY MIGHT NOT BE IDEAL.

    if params[:petschosen].present?

      array_that_has_petsitters_who_meet_criteria_pettypes = Array.new

      array_with_ids_of_pets_chosen = params[:petschosen]

      array_with_ids_of_pets_chosen.each do | pet__type_id |

          # so firstly we get the pettype object that has the id which is one of the elements of the array using the Pettype model
          object_of_pettype_from_db = Pettype.find(pet__type_id)

          # now the .petsitters only works because of the has_many through association 
          # originally upon finding the object_of_pettype_from_db we would have to apply .junctionofpetsitterandpettypes to get an array of junction objects from join table that have their pettype_id same as the id on the pettype from db 
          # then for each junction object/instance in the array, we would have to apply the .petsitter which is enabled by the belongs_to :petsitter association on the join table
           # then we take all those petsitters and join them into an array 
           # then we do the same for the next pettype object if there more than one petschosen 
           # this slowly becomes tideous
           # the HAS_MANY THROUGH ASSOCIATION THAT WE WRITE ON PETSITTERS AND PETTYPES MODELS ALLOWS US TO FIND AN ARRAY OF ALL PETSITTERS THAT CAN CARE FOR A PETTYPE GIVEN A PETTYPE OBJECT - SO DON'T HAVE TO PASS THROUGH JOIN TABLE
          all_pet_sitters_that_can_care_for_one_of_the_pets_from_element_array = object_of_pettype_from_db.petsitters
          # all_pet_sitters_that_can_care_for_one_of_the_pets_from_element_array WILL FOR SURE BE AN ARRAY EVEN IF THERE IS ONE ELEMENT OR NO ELEMENT

          # the + operator allows us to add elements of an array to another
          # a = [1,2,3]  b=[6,7,8]
          # a + b = [1,2,3,6,7,8]
          # a = a + b
          # a = [1,2,3,6,7,8]
          array_that_has_petsitters_who_meet_criteria_pettypes = array_that_has_petsitters_who_meet_criteria_pettypes + all_pet_sitters_that_can_care_for_one_of_the_pets_from_element_array

      end
 
    end #end if
    
  
  end # end of action







end #end of class
