class RenameMobileOfUser < ActiveRecord::Migration
  def change
    remove_column :users, :mobile
    add_column :users, :mobile, :string, limit: 15
  end
end
