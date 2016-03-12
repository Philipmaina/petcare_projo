# REASON FOR THIS CHANGE IN COLUMN NAME IS BECAUSE I WANTED CONSISTENCY IN THE NAMES OF THE CONTACT FIELDS IN PETOWNERS AND PETSITTERS TABLE

# format for renaming:
	# rename_column(keyword) :table_name , :old_column_name , :new_column_name
	
class ChangeColumnNamesForContacts < ActiveRecord::Migration
  def change
  	rename_column :petsitters, :contact_no_one , :contact_line_one
  	rename_column :petsitters, :contact_no_two , :contact_line_two
  end
end
