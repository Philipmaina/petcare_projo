class CreatePets < ActiveRecord::Migration
  def change
    create_table :pets do |t|
      t.references :pettype, index: true, foreign_key: true
      t.references :petowner, index: true, foreign_key: true
      t.string :pet_name
      t.integer :years_pet_lived
      t.integer :months_pet_lived
      t.string :gender
      t.string :breed
      t.string :size_of_pet
      t.string :default_pet_pic_file_name
      t.string :alternative_pic_file_name
      t.text :care_handle_instructions

      t.timestamps null: false
    end
  end
end
