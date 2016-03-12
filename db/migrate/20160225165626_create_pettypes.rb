class CreatePettypes < ActiveRecord::Migration
  def change
    create_table :pettypes do |t|
      t.string :type_name

      t.timestamps null: false
    end
  end
end
