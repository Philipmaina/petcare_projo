class CreatePetowners < ActiveRecord::Migration
  def change
    create_table :petowners do |t|
      t.string :first_name
      t.string :surname
      t.string :other_names
      t.date :date_of_birth
      t.string :personal_email
      t.string :contact_line_one
      t.string :contact_line_two
      t.string :profile_pic_file_name
      t.references :ResidentialArea, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
