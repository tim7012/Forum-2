class CommentsController < ApplicationController

before_action :set_post
before_action :authenticate_user!, :except => [:show]


  def show

  end


  def new
    @comment = @post.comments.build

  end

  def edit

  end

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      @post.comment_last_updated_at = @comment.updated_at
      @post.save
      redirect_to post_path(@post)
    else
      render :action => :new
    end
  end

  def edit
    @comment = @post.comments.find(params[:id])
  end

  def update
    @comment = @post.comments.find(params[:id])
    if @comment.update(comment_params)
      @post.comment_last_updated_at = @comment.updated_at
      @post.save
      redirect_to post_path(@post)
    else
      render :action => :edit
    end
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    @comment.destroy

    if @post.comments_count > 1
      @post.comment_last_updated_at = Comment.order("updated_at").last.updated_at
    else
      @post.comment_last_updated_at = nil
    end
    @post.save

    redirect_to post_path(@post)
  end

  protected

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:content, :draft)
  end

end
