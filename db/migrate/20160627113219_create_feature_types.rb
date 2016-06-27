class CreateFeatureTypes < ActiveRecord::Migration
  def change
    create_table :feature_types do |t|
      t.string :name
      t.text :comment
      t.integer :position

      t.timestamps null: false
    end
  end
end
