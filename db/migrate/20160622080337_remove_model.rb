class RemoveModel < ActiveRecord::Migration
  def change
    remove_column :posts, :order
  end
end
