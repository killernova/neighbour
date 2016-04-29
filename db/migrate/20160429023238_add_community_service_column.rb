class AddCommunityServiceColumn < ActiveRecord::Migration
  def change
    add_column :community_services, :address, :string, limit: 100
  end
end
