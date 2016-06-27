class CreateRights < ActiveRecord::Migration
  def change
    create_table :rights do |t|
      t.string :name
      t.integer :position

      t.timestamps null: false
    end
  end
end
