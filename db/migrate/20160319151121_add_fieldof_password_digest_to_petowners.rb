class AddFieldofPasswordDigestToPetowners < ActiveRecord::Migration
  def change
    add_column :petowners, :password_digest, :string
  end
end
