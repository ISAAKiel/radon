class CreatePrmats < ActiveRecord::Migration
  def change
    create_table :prmats do |t|
      t.string :name
      t.integer :position

      t.timestamps null: false
    end
  end
end
