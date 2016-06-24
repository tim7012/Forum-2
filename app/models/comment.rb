class Comment < ActiveRecord::Base
  validates_presence_of :content
  #validates_nume_of

  belongs_to :post, :counter_cache => true
  belongs_to :user
end
