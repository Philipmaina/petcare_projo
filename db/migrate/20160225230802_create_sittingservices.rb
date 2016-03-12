class CreateSittingservices < ActiveRecord::Migration
  def change
    create_table :sittingservices do |t|
      t.string :service_name
      t.text :service_description
      t.string :place_offered

      t.timestamps null: false
    end
  end
end
