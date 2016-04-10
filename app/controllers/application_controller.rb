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

    # HOLD ON THIS WILL BE SOME KINDA LONG CODE THAT NEEDS UNDERSTANDING 
    # NOTE TO FUTURE SELF : READ ON LAMBDAS AND PROCS 

    # So my approach to this is create an array of petsitter for each criterion e. we have an array of petsitter objects that meet the criteria of the pet service specified , then we have an array of petsitter objects that meet the criteria of being available between the pickup date and dropoff date , then we have another array of petsitter objects that meet the criterion of pets that the user(petowner) has chosen to be cared for - so which petsitters can care for either one or many of the pets specified(OR)......BLAH BLAH BLAH

    # _____1) Create array of petsitters that care for the pets specified______

    # Reason first of why to bring even a petsitter who just cares for one of the pets specified(OR) and not enforce that the petsitter must care for all(AND) is because it is hard to find a sitter say who can take care of a dog, a parrot and a horse. So the petowner can just be presented with the petsitters who can care for one or the other AND THE PETOWNER CAN MAKE MANY DIFFERENT BOOKINGS - maybe his dog will be cared for by this petsitter 1 then his horse will be cared for by petsitter 2 - ESSENTIALLY IT IS NOT IDEAL BECAUSE YOU WOULD RATHER KNOW THAT ALL YOUR PETS ARE BEING CARED FOR BY ONE PERSON RATHER THAN BY MANY DIFFERENT PEOPLE COZ IT'S HARDER TO TRACK ALL YOUR PET'S PROGRESS DURING YOUR PERIOD AWAY BUT IT IS A DISADVANTAGE TO HAVE AN OCUURRENCE WHERE A MESSAGE IS DISPLAYED SAYING NO PETSITTERS CAN CARE FOR YOUR PETS - SO ITS JUST  BETTER TO AT LEAST PRESENT THEM WITH OPTIONS EVEN THOUGH THEY MIGHT NOT BE IDEAL.

    array_that_has_petsitters_who_meet_criteria_pettypes = Array.new

    if params[:petschosen].present?

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


    # ____2) Create array of petsitters that meet the criteria that follow___
    # __________i)The residential area chosen________________________________
    # _________ii)The sitting service chosen_________________________________
    # ________iii)The price rate chosen______________________________________
    
    # so firstly lets get all the petsitters that meet the requirements of the residentialarea chosen - keep in mind one residentialarea has_many petsitters - so we get method of .petsitters for free on an object_of_residentialarea
    object_of_residentialarea_from_db = ResidentialArea.find( params[:residential_area_id] )

    # can use .petsitters on residentialarea object because of has_many association - redundant documentation but oh well !!
    array_of_all_petsitters_that_meet_requirement_of_residentialarea = object_of_residentialarea_from_db.petsitters


    # Now we will use .select method in ruby that takes a block
    # .select - Returns a new array containing all elements of previous array for which the given block returns a true value.
    # say you have array a = [1,2,3,4,5,6,7]
    # then you apply a.select{ |elementinarray| 
                          # elementinarray <= 4.5  
                     # }
    # this by itself will return an array [1,2,3,4]
    # however a will still have [1,2,3,4,5,6,7]
    # so it is up to the developer to assign that returned array to a new array like so
    #       newarray = a.select{ |elementinarray| 
                          # elementinarray <= 4.5  
                     # }
    # so now newarray = [1,2,3,4]

    second_array_that_has_petsitterobjects_whosatisfythreecriteria = Array.new

    second_array_that_has_petsitterobjects_whosatisfythreecriteria = array_of_all_petsitters_that_meet_requirement_of_residentialarea.select{ |petsitterobject_element_in_array| 

        # remember a petsitter can have many sitting services as defined by the has_many through association in the model(check it out).
        # So applying .sittingservices on a petsitter object(which is an element of array) brings an array of sitting services that that petsitter can do 
         # .include? is a method that returns true if a given element/thing is present in an array and false if it isnt there 
         # what you want to search for is put in the parameter section .include?( )

         # so for each petsitter object in array_of_all_petsitters_that_meet_requirement_of_residentialarea we check for those who do the sittingservice given AND those who charge less than or equal to the price chosen by petowner.
         # REMEMBER WE APPLY AND BECAUSE WE WANT TO SATISFY BOTH  - COZ WE DONT WANT TO BRING THE PETOWNER AN OPTION OF PETSITTERS WHO ONLY CHARGE A PRICE OR LESS BUT DONT OFFER THAT SERVICE OR OPTION OF PETSITTERS WHO OFFER A SERVICE BUT CHARGE MORE COSTLY THAN WAS CHOSEN

        ( petsitterobject_element_in_array.sittingservices.include?( Sittingservice.find( params["sitting_service"] ) ) ) && ( petsitterobject_element_in_array.night_charges <= params[:pricerate].to_i )


    }

    

    # ________3) Find all petsitter whose unavailable dates don't coincide with the days chosen as period of care________

    @final_array_with_all_petsitter_objects_that_satisfy_all_criteria = Array.new

    # so we are receiving drop off date and pickup date from params, therefore we need to get petsitters whose unavailable dates are not in the range btwn the dropoffdate and pickup date

    # firstly for efficiency lets take the two arrays above of petsitter objects and see what petsitter objects they have in common - we will store what they have in common in this third array 
    # the & operator applies intersection between the two array creating a new array with what  is common between the two
    thirdarray_with_petsitterobjects_that_satisfies_first_two_stages = array_that_has_petsitters_who_meet_criteria_pettypes & second_array_that_has_petsitterobjects_whosatisfythreecriteria

    # .any? will return true if there is at least one element
    # remember if the third_array has no elements there is no point continuing because you can't find petsitters who can satisfy the criteria placed thus far - therefore no point checking the last criterion
    if thirdarray_with_petsitterobjects_that_satisfies_first_two_stages.any?

      dropoffdate = params[:dropoffdate].to_date
      pickupdate = params[:pickupdate].to_date

      array_containing_dates_for_period_of_care = (dropoffdate..pickupdate).to_a

      thirdarray_with_petsitterobjects_that_satisfies_first_two_stages.each do | petsitterelement|

          # array.map executes the given block for each element of the array but returns a new array whose elements are the return values of each iteration of the block 
          # so in our case we dont want the array of unavailabledates objects, we just want the value of the attribute unavailable_dates_on of each unavailabledates object and make an array of those values
          array_of_all_unavailabledates_for_specificpetsitter = petsitterelement.unavailabledates.map{ |elem| 

              elem.unavailable_dates_on

          }

          # if we intersect the two arrays as shown below by & operator end we end up getting an empty array, that means the petsitter that we are currently inspecting doesn't have any of his unavailable dates colliding with the period of care the petowner wants - so his/she is A PERFECT MATCH - THEREFORE WE CAN ADD THAT PETSITTER OBJECT TO FINAL ARRAY
          if (array_containing_dates_for_period_of_care & array_of_all_unavailabledates_for_specificpetsitter).empty?

            @final_array_with_all_petsitter_objects_that_satisfy_all_criteria.push(petsitterelement)
            
          end #end of inner if

      end #end of do
  
    end #end of outer if


    # flash[:notice]’s message will persist to the next action and should be used when redirecting to another action via the ‘redirect_to’ method.(only disappears after second request)
    # flash.now[:notice]’s message will be displayed in the view your are rendering via the ‘render’ method.





    if @final_array_with_all_petsitter_objects_that_satisfy_all_criteria.any?
        # setup flashes then show in application layouts
        flash.now[:notice] = "We have found petsitter(s) that match your criteria"
    else
       flash.now[:alert] = "sorry!! We have not found petsitter(s) that match your criteria."
    end

    @all_residential_areas_in_nairobi = ResidentialArea.all
    @allpets = Pettype.all
    @sittingservicesoffered = Sittingservice.all
    render 'search_page_for_petowners'


    
  end # end of action

  def show_page_petsitter_querry

    @petsitter_querried = Petsitter.find( params[:id] )

    
    
  end




  # THESE METHODS ARENT REALLY ACTIONS COZ WE CAN'T ROUTE DIRECTLY TO THEM
  private



    # NOTE: HELPER METHODS AREN'T ACCESSIBLE INSIDE CONTROLLERS

    # ------------METHODS USED BY BOTH HELPERS AND CONTROLLERS------------- 
    # TO BE CALLED FROM ANY VIEW AND ANY CONTROLLER
    def current_petsitter

      petsitterobjectview = Petsitter.find_by(id: session[:petsitter] )
      return petsitterobjectview
      
    end

    def current_petowner

      petownerobjectview = Petowner.find_by(id: session[:petowner] )
      return petownerobjectview
      
    end


    # HOW TO MAKE THE METHODS ABOVE AVAILABLE TO ANY VIEW
    helper_method :current_petsitter , :current_petowner #Declare a controller method as a helper

    # ------------------------------------------------------------------


    

    def require_petsitter_signin

      # how we can tell if a user who is a petsitter is signed in is by checking current_petsitter method which would either return nil or a petsitter object

      # we want to redirect to sign in page unless there is a petsitter object(meaning a petsitter is signed in)
      unless current_petsitter

        # if we enter inside this block it means there is no signed in user and the action that was to be run whether edit or update wont be run because we will redirect
        redirect_to new_session_path , alert: "Please sign in first!!"

      end

    end


    def require_petowner_signin

      unless current_petowner

        redirect_to new_session_path , alert: "Please sign in first!!"

      end

    end




    




    



  







end #end of class
