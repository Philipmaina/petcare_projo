class CreateNotificationforpetowners < ActiveRecord::Migration
  def change
    create_table :notificationforpetowners do |t|
      t.references :petowner, index: true, foreign_key: true
      t.references :booking, index: true, foreign_key: true
      t.boolean :read_status , default: false
      t.string :type_of_notification

      t.timestamps null: false
    end
  end
end
