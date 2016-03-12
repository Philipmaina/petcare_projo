class CreateUnavailabledates < ActiveRecord::Migration
  def change
    create_table :unavailabledates do |t|
      t.references :petsitter, index: true, foreign_key: true
      t.date :unavailable_dates_on

      t.timestamps null: false
    end
  end
end
