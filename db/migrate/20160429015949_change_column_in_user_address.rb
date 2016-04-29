class ChangeColumnInUserAddress < ActiveRecord::Migration
  def change
    remove_column :user_addresses, :living_area, :string
    add_column :user_addresses, :area, :string, limit: 60
  end
end
