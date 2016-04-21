class ChangeTheAvatarOfUser < ActiveRecord::Migration
  def change
    remove_column :users, :avator
    add_column :users, :avatar, :string, limit: 500
  end
end
