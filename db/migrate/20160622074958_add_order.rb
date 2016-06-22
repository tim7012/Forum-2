class AddOrder < ActiveRecord::Migration
  def change
    add_column :posts, :order, :string
  end
end
