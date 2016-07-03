class AddImageToComments < ActiveRecord::Migration
  def change
    add_attachment :comments, :logo
  end
end
