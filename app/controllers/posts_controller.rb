class PostsController < ApplicationController

  before_action :set_post, :only => [:show, :edit, :update, :destroy, :favourite, :unfavourite]
  before_action :authenticate_user!, :except => [:index, :show]

  def index

    if params[:sort]&&params[:sort] == "Ruby"
      @posts = Category.find_by(:name =>"Ruby").posts
    elsif params[:sort]&&params[:sort] == "Perl"
      @posts = Category.find_by(:name =>"Perl").posts
    elsif params[:sort]&&params[:sort] == "Java"
      @posts = Category.find_by(:name => "Java").posts
    else
      @posts = Post.all.order("updated_at DESC")
    end

    if current_user &&current_user.admin?
      @posts = Post.all.order("updated_at DESC")
    elsif current_user
      @posts = @posts.where("user_id = ? or status = ?", current_user.id, "release")
    elsif
      @posts = @posts.where("status = 'release'")
    end

    if params[:order]
      if params[:order] == 'last_comment_time'
        @posts = @posts.order("comment_last_updated_at DESC")
      elsif params[:order] && params[:order] == 'comment_number'
        @posts = @posts.order("comments_count DESC")
      elsif params[:order] && params[:order] == "topic_clicks"
        @posts = @posts.order("clicked DESC")
      end
    end

    @posts = @posts.page(params[:page]).per(6)
    @categories = Category.all

  end

  def show

    @post.clicked += 1
    @post.save



    @comments = @post.comments.where("user_id = current_user.id").order("updated_at desc")

  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user

    if @post.save

      flash[:notice] = "Post was successfully created"
      redirect_to :action => :index
    else
      render :action => :new
    end
  end

  def edit
    unless current_user.author?(@post)||current_user.admin?
      flash[:alert] = "Not authorized"
      redirect_to posts_path
    end
  end

  def update
    if @post.update(post_params)
      if params[:destroy_logo]
          @post.logo = nil
          @post.save
      end
        flash[:notice] = "Update successfully"
        redirect_to posts_path
    else
       render :action => :edit
    end
  end

  def destroy

    if current_user.author?(@post)||current_user.admin?
      @post.destroy
      flash[:alert] = "The post was successfully deleted"
    else
      flash[:alert] = "Not authorized"
    end
    redirect_to posts_path
  end

  def about
    @users = User.all
    @posts = Post.all
    @comments = Comment.all
  end

  def favourite

    @favourite = @post.find_my_favourite(current_user)
    unless @favourite
      @favourite = FavouritePost.create!(:post => @post, :user => current_user)
    end
    respond_to do |format|
      format.html{redirect_to :back}
      format.js
    end
  end

  def unfavourite

    @favourite = @post.find_my_favourite(current_user)
    if @favourite
      @favourite.destroy
    end
    respond_to do |format|
      format.html {redirect_to :back}
      format.js {render "favourite"}
    end
  end

  protected

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :clicked, :status, :logo, :category_ids => [])
  end
end
