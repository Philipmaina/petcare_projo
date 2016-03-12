class CreateResidentialAreas < ActiveRecord::Migration
  def change
    create_table :residential_areas do |t|
      t.string :name_of_location

      t.timestamps null: false
    end
  end
end
