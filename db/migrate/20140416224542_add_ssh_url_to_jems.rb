class AddSshUrlToJems < ActiveRecord::Migration
  def change
  	add_column :jems, :ssh_url, :string
  end
end
