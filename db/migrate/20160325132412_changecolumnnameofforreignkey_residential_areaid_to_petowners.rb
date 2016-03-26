class ChangecolumnnameofforreignkeyResidentialAreaidToPetowners < ActiveRecord::Migration
  def change
  	rename_column :petowners, :ResidentialArea_id , :residential_area_id
  end
end
