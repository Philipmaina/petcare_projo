class CreatePetsitters < ActiveRecord::Migration
  def change
    create_table :petsitters do |t|
      t.string :first_name
      t.string :surname
      t.string :other_names
      t.date :date_of_birth
      t.references :ResidentialArea, index: true, foreign_key: true
      t.string :personal_email
      t.string :contact_no_one
      t.string :contact_no_two
      t.integer :no_of_yrs_caring
      t.integer :no_of_pets_owned
      t.string :type_of_home
      t.boolean :presence_of_open_area_outside_home
      t.string :work_situation
      t.integer :day_charges
      t.integer :night_charges
      t.string :default_pic_file_name
      t.string :listing_name
      t.text :profile_description

      t.timestamps null: false
    end
  end
end
