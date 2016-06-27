class EditDraft < ActiveRecord::Migration
  def change
    remove_column :posts, :draft
    remove_column :comments, :draft

    add_column :posts, :status, :string
  end
end
