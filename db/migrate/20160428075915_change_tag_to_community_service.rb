class ChangeTagToCommunityService < ActiveRecord::Migration
  def change
    remove_column :community_services, :tag, :integer
    add_column :community_services, :tag, :string, limit: 20, default: '其他'
  end
end
