Rails.application.routes.draw do

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  root 'petowners#index' #this is the default home page(landing page)

   # -----------------------ADDITIONAL ROUTES---------------------------------

  # -----------1) routes for multistep form of PETOWNERS ---------------------------
  get "/petowners/new/basic_predetails" => "petowners#new_basic_predetails" , as: "new_petowner_basic_predetails"
  post "/petowners/new/basic_predetails" => "petowners#create_basic_predetails"


  get "/petowners/:id/personal_details" => "petowners#edit_petowner_personal_details" , as: "edit_petowner_personal_details"
  patch "/petowners/:id/personal_details" => "petowners#update_petowner_personal_details"

  # --------------------------------------------------------------------------------


  # ---------2) routes for multistep form of PETSITTERS ----------------------------
  get "/petsitters/new/basic_predetails" => "petsitters#new_basic_predetails" , as: "new_petsitter_basic_predetails"
  post "/petsitters/new/basic_predetails" => "petsitters#create_basic_predetails"


  get "/petsitters/:id/personal_details" => "petsitters#edit_petsitter_personal_details" , as: "edit_petsitter_personal_details"
  patch "/petsitters/:id/personal_details" => "petsitters#update_petsitter_personal_details"

  get "/petsitters/:id/experience_and_skills_details" => "petsitters#edit_petsitter_experience_and_skills_details" , as: "edit_experience_and_skills_details"
  patch "/petsitters/:id/experience_and_skills_details" => "petsitters#update_petsitter_experience_and_skills_details"


  get "/petsitters/:id/home_details" => "petsitters#edit_petsitter_home_details" , as: "edit_petsitter_home_details"
  patch "/petsitters/:id/home_details" => "petsitters#update_petsitter_home_details"



  # --------------------------------------------------------------------------------
  resources :unavailabledates
  resources :junctionofservicesandpetsitters
  resources :sittingservices
  resources :junctionofpetsitterandpettypes
  resources :petsitters
  resources :pets
  resources :pettypes
  resources :residential_areas
  resources :petowners


 

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
