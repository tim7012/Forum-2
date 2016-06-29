class CommentsController < ApplicationController

before_action :set_post



  def show

  end


  def new
    @comment = @post.comments.new

  end

  def edit

  end

  def create
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      # TODO define a new method for updating comment time
      # def update_comment_time(options = {})
      #   self.update!(:last_comment_at = comment.updated_at )
      # end
      # e.g. @post.update_comment_time(:comment => @comment)
      @post.comment_last_updated_at = @comment.updated_at
      @post.save
      redirect_to post_path(@post)
    else
      render :action => :new
    end
  end

  def edit
    if @post.user != current_user
      # Same as posts#edit
      flash[:alert] = "not authorized"
      redirect_to post_path(@post)
    else
      @comment = @post.comments.find(params[:id])
    end
  end

  def update
    @comment = @post.comments.find(params[:id])
    if @comment.update(comment_params)
      @post.comment_last_updated_at = @comment.updated_at # TODO
      @post.save
      redirect_to post_path(@post)
    else
      render :action => :edit
    end
  end

  def destroy

    if @post.user != current_user # TODO
      flash[:alert] = "Not authorized"
      redirect_to post_path(@post)
    else
      @comment = @post.comments.find(params[:id])
      @comment.destroy

      if @post.comments_count > 1
        # @post.update_comment_time!(Comment.order("updated_at").last)
        @post.comment_last_updated_at = Comment.order("updated_at").last.updated_at
      else
        @post.comment_last_updated_at = nil
      end
      @post.save

      redirect_to post_path(@post)
    end
  end

  protected

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

end
