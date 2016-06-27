class CreateDatingMethods < ActiveRecord::Migration
  def change
    create_table :dating_methods do |t|
      t.string :name
      t.integer :position

      t.timestamps null: false
    end
  end
end
