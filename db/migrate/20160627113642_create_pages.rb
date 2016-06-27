class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :name
      t.text :content
      t.integer :position

      t.timestamps null: false
    end
  end
end
