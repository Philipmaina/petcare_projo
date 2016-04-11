class CreateNotificationforpetsitters < ActiveRecord::Migration
  def change
    create_table :notificationforpetsitters do |t|
      t.references :petsitter, index: true, foreign_key: true
      t.references :booking, index: true, foreign_key: true
      t.boolean :read_status , default: false
      t.string :type_of_notification

      t.timestamps null: false
    end
  end
end
