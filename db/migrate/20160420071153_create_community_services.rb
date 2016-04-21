class CreateCommunityServices < ActiveRecord::Migration
  def change
    create_table :community_services do |t|
      t.integer :user_id, limit: 7, index: true
      t.string :title, limit: 50
      t.text :content
      t.integer :community_id, limit: 7, index: true
      t.string :tag, limit: 20

      t.timestamps null: false
    end
  end
end
