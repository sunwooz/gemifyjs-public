class RemoveScriptFromJem < ActiveRecord::Migration
  def change
    remove_column :jems, :script, :string
  end
end
