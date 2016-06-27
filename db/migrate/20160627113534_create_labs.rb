class CreateLabs < ActiveRecord::Migration
  def change
    create_table :labs do |t|
      t.string :name
      t.references :dating_method, index: true, foreign_key: true
      t.string :lab_code
      t.string :country
      t.boolean :active
      t.integer :position

      t.timestamps null: false
    end
  end
end
