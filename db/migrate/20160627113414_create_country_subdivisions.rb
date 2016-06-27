class CreateCountrySubdivisions < ActiveRecord::Migration
  def change
    create_table :country_subdivisions do |t|
      t.string :name
      t.integer :position
      t.references :country, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
