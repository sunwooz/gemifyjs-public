class AddCommitMessageToJems < ActiveRecord::Migration
  def change
  	add_column :jems, :commit_message, :string
  end
end
