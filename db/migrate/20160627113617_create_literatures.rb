class CreateLiteratures < ActiveRecord::Migration
  def change
    create_table :literatures do |t|
      t.string :short_citation
      t.string :year
      t.string :author
      t.text :long_citation
      t.string :url
      t.boolean :approved
      t.text :bibtex

      t.timestamps null: false
    end
  end
end
