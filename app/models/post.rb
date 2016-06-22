class Post < ActiveRecord::Base
  validates_presence_of :title

  has_many :comments, :dependent => :destroy

  has_many :post_categoryships
  has_many :categorys, :through => :post_categoryships

  belongs_to :user
end
