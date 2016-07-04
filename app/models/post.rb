class Post < ActiveRecord::Base
  validates_presence_of :title

  has_many :comments, :dependent => :destroy

  has_many :post_categoryships
  has_many :categories, :through => :post_categoryships

  belongs_to :user

  has_many :favourite_posts, :dependent => :destroy
  has_many :favourite_by, :through => :favourite_posts, :source => :user, :dependent => :destroy

  has_many :likes, :dependent => :destroy
  has_many :likes_by, :through => :likes, :source => :user, :dependent => :destroy

  has_many :subscribes, :dependent => :destroy
  has_many :subscribes_by, :through => :subscribes, :source => :user, :dependent => :destroy

  has_attached_file :logo, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\Z/

  def find_my_favourite(user)

    self.favourite_posts.where(:user => user).first
  end

  def find_my_like(user)
    self.likes.where(:user => user).first
  end

  def find_my_subscribe(user)
    self.subscribes.where(:user => user).first
  end

end
