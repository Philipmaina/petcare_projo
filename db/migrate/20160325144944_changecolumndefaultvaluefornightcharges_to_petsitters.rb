class ChangecolumndefaultvaluefornightchargesToPetsitters < ActiveRecord::Migration
	# THE REASON WHY I'M CHANGING THE DEFAULT VALUE IS BECAUSE WHEN RUNNING QUERY ON APPLICATION CONTROLLER I WANT TO USE .select method which does not accept has a condition >= ,that condition does not accept a nil value
 	# undefined method `>=' for nil:NilClass will be the error 


	#  array_of_all_petsittersobjects_who_live_in_specified_criterion.select{ |a| a.night_charges >= 300 }

	# usually by default if you don't specify default value it will be nil in the database because it doesn't make sense to have a nil charge

	# change_column_default(table_name, column_name, default) 
	# Sets a new default value for a column
	# change_column_default(:accounts, :authorized, 1)
  def change
  	change_column_default(:petsitters , :night_charges , 0)
  	change_column_default(:petsitters , :day_charges , 0)
  end
  
end
