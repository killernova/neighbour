class ChangeUser < ActiveRecord::Migration
  def change
    remove_column :users, :wexin_openid
    add_column :users, :weixin_openid, :string, index: true
  end
end
