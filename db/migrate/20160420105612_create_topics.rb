class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.integer :user_id, limit: 7
      t.integer :community_id, limit: 7
      t.string :title, limit: 50
      t.text :content

      t.timestamps null: false
    end
  end
end
