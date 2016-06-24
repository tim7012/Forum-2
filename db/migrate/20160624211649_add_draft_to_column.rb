class AddDraftToColumn < ActiveRecord::Migration
  def change
    add_column :posts, :draft, :boolean, :default => "false"
    add_column :comments, :draft, :boolean, :default => "false"
  end
end
