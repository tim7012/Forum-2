class Addcolumns < ActiveRecord::Migration
  def change
    add_column :comments, :user_id, :integer



    add_index :comments, :user_id
    add_index :posts, :user_id
  end
end
