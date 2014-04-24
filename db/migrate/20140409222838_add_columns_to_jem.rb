class AddColumnsToJem < ActiveRecord::Migration
  def change
    add_column :jems, :author, :string
    add_column :jems, :base_name, :string
    add_column :jems, :description, :text
    add_column :jems, :email, :string
    add_column :jems, :summary, :text
    add_column :jems, :homepage, :string
  end
end
