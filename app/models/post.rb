class Post < ActiveRecord::Base
  validates_presence_of :title

  has_many :comments, :dependent => :destroy

  has_many :post_categoryships
  has_many :categories, :through => :post_categoryships

  belongs_to :user

  has_many :favourite_posts, :dependent => :destroy
  has_many :favourite_by, :through => :favourite_posts, :source => :user, :dependent => :destroy

  def find_my_favourite(user)

    self.favourite_posts.where(:user => user).first
  end

end
