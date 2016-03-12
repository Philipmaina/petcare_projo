class CreateJunctionofservicesandpetsitters < ActiveRecord::Migration
  def change
    create_table :junctionofservicesandpetsitters do |t|
      t.references :petsitter, index: true, foreign_key: true
      t.references :sittingservice, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
