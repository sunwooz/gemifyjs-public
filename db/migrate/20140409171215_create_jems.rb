class CreateJems < ActiveRecord::Migration
  def change
    create_table :jems do |t|
      t.string :name
      t.string :github
      t.timestamps
    end
  end
end
