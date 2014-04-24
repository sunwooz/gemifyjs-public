class ChangeActivityUserColumn < ActiveRecord::Migration
  def change
    rename_column :activities, :user_id, :jem_id
  end
end
