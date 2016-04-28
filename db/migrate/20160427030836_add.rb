class Add < ActiveRecord::Migration
  def change
    add_column :photos, :community_news_id, :integer, index: true
    add_column :photos, :community_service_id, :integer, index: true
    add_column :comments, :community_service_id, :integer, index: true
  end
end
