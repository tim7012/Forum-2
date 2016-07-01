class Category < ActiveRecord::Base
  ##
  validates :name, presence:true

  has_many :post_categoryships
  has_many :posts, :through => :post_categoryships

end
