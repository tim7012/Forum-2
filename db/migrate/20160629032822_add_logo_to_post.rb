class AddLogoToPost < ActiveRecord::Migration
  def change
     add_attachment :posts, :logo
  end
end
