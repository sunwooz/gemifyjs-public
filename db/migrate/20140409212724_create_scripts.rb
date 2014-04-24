class CreateScripts < ActiveRecord::Migration
  def change
    create_table :scripts do |t|
      t.string :file
      t.integer :jem_id
      t.timestamps
    end
  end
end
