class AddTotalOnlineTimeToUser < ActiveRecord::Migration
  def change
    add_column :users, :total_online_time, :float
  end
end
