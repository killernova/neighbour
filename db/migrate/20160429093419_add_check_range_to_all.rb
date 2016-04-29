class AddCheckRangeToAll < ActiveRecord::Migration
  def change
    add_column :users, :show_all_news, :integer, limit: 2
    add_column :users, :show_all_services, :integer, limit: 2
    add_column :users, :show_all_topics, :integer, limit: 2
  end
end
