class Addcounterandcommentupdatedtime < ActiveRecord::Migration
  def change
    add_column :posts, :comments_count, :integer, :default => 0
    add_column :posts, :comment_last_updated_at, :datetime
    add_column :posts, :clicked, :integer, :default => 0
  end
end
