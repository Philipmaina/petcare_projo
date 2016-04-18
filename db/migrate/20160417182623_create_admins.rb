class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.string :first_name
      t.string :surname
      t.references :residential_area, index: true, foreign_key: true
      t.string :personal_email
      t.string :contact_line_one
      t.string :contact_line_two
      t.string :position_in_company
      t.string :password_digest

      t.timestamps null: false
    end
  end
end
