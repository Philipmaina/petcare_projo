class AddPasswordDigestColumnToPetsitters < ActiveRecord::Migration
  def change
    add_column :petsitters, :password_digest, :string
  end
end
