class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception



  # SINCE YOU CAN'T BYPASS THE CONTROLLER AND GO STRAIGHT TO THE VIEW WHEN DEFINING ROUTES - IT'S A VIOLATION AGAINST MVC PATTERN, I TEND TO USE THIS CONTROLLER AS ROUTES FOR PAGES THAT FALL OUTSIDE A SPECIFIC RESOURCE
  
  def index
  	
  end

  def page_for_choosing_type_of_registration
  	
  end

end
