class CreateCultures < ActiveRecord::Migration
  def change
    create_table :cultures do |t|
      t.string :name
      t.integer :position

      t.timestamps null: false
    end
  end
end
