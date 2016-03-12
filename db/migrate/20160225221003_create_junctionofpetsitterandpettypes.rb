class CreateJunctionofpetsitterandpettypes < ActiveRecord::Migration
  def change
    create_table :junctionofpetsitterandpettypes do |t|
      t.references :pettype, index: true, foreign_key: true
      t.references :petsitter, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
