class ChangeColumnOfCommunityService < ActiveRecord::Migration
  def change
    remove_column :community_services, :tag, :string
    add_column :community_services, :tag, :integer, limit: 2
  end
end
