class Admin::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin

  layout "admin"

  def index
    @posts = Post.all

  end





  def check_admin
    unless current_user.admin?
      raise ActiveRecord::RecordNotFound
    end
  end


end
