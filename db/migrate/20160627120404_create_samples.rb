class CreateSamples < ActiveRecord::Migration
  def change
    create_table :samples do |t|
      t.references :lab, index: true, foreign_key: true
      t.string :lab_nr
      t.integer :bp
      t.integer :std
      t.float :delta_13_c
      t.float :delta_13_c_std
      t.references :prmat, index: true, foreign_key: true
      t.text :prmat_comment
      t.text :comment
      t.string :feature
      t.references :feature_type, index: true, foreign_key: true
      t.references :phase, index: true, foreign_key: true
      t.references :site, index: true, foreign_key: true
      t.boolean :approved
      t.references :right, index: true, foreign_key: true
      t.references :dating_method, index: true, foreign_key: true
      t.string :contact_e_mail
      t.string :creator_ip

      t.timestamps null: false
    end
  end
end
