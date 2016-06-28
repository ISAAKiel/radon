class AddLastRequestAtToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_request_at, :datetime
  end
end
