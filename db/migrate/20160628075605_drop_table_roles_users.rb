class DropTableRolesUsers < ActiveRecord::Migration
  def up
    drop_table :roles_users
  end
  def down
    create_table :roles_users, id: false do |t|
      t.references :user
      t.references :role
    end
  end
end
