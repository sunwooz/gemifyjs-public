class AddScriptToJems < ActiveRecord::Migration
  def change
    add_column :jems, :script, :string
  end
end
