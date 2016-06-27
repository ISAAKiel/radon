class CreateLiteraturesSamples < ActiveRecord::Migration
  def change
    create_table :literatures_samples do |t|
      t.references :literature, index: true, foreign_key: true
      t.references :sample, index: true, foreign_key: true
      t.string :pages

      t.timestamps null: false
    end
  end
end
