class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.date :start_date
      t.date :end_date
      t.references :petowner, index: true, foreign_key: true
      t.string :pets_booked_for
      t.references :petsitter, index: true, foreign_key: true
      t.references :residential_area, index: true, foreign_key: true
      t.integer :no_of_night_days_for_pet_stay
      t.decimal :total_price_of_stay
      t.references :sittingservice, index: true, foreign_key: true
      t.string :reason_of_booking
      t.boolean :petsitter_acceptance_confirmation
      t.boolean :petsitter_booking_cancellation
      t.boolean :completion_of_pet_stay

      t.timestamps null: false
    end
  end
end
