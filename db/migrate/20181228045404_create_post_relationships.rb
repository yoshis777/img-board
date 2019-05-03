class CreatePostRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :post_relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
  end
end
