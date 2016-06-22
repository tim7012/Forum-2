class CommentsController < ApplicationController

before_action :set_post


  def show

  end


  def new
    @comment = @post.comments.build

  end

  def edit

  end

  def create
    @comment = @post.comments.build(comment_params)
    if @comment.save
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
      redirect_to post_path(@post)
    else
      render :action => :edit
    end
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    @comment.destroy

    redirect_to post_path(@post)
  end

  protected

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

end
