class AddTagToTopic < ActiveRecord::Migration
  def change
    add_column :topics, :tag, :string, limit: 20, default: '其他'
  end
end
