class CreatePostsTable < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :body
      t.integer :user_id
      end
  end
end
