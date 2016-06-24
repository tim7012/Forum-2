class ProfilesController < ApplicationController

  def info
    @profile = User.find(params[:id])
    @posts = Post.where("user_id = #{params[:id]}")
    @comments = Comment.where("user_id = #{params[:id]}")
  end

end
