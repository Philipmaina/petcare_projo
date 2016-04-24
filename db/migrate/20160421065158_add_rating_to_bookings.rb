class AddRatingToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :rating_after_complete_pet_stay, :integer
  end
end
