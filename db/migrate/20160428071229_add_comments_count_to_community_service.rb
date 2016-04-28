class AddCommentsCountToCommunityService < ActiveRecord::Migration
  def change
    add_column :community_services, :comments_count, :integer, default: 0
  end
end
