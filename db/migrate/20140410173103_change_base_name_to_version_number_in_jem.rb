class ChangeBaseNameToVersionNumberInJem < ActiveRecord::Migration
  def change
    rename_column :jems, :base_name, :version_number
  end
end
