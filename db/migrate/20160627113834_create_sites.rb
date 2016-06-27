class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :name
      t.string :parish
      t.string :district
      t.references :country_subdivision, index: true, foreign_key: true
      t.float :lat
      t.float :lng

      t.timestamps null: false
    end
  end
end
