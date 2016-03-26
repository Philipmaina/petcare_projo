class RenamecolumnofforeignkeyResidentialAreaidToPetsitters < ActiveRecord::Migration

  def change
  	rename_column :petsitters, :ResidentialArea_id , :residential_area_id
  end
  
end
