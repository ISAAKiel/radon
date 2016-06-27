class CreatePhases < ActiveRecord::Migration
  def change
    create_table :phases do |t|
      t.string :name
      t.references :culture, index: true, foreign_key: true
      t.boolean :approved
      t.integer :position

      t.timestamps null: false
    end
  end
end
