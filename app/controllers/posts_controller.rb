class PostsController < ApplicationController

  before_action :set_post, :only => [:show]
  before_action :authenticate_user!, :except => [:index, :show]

  def index

    @posts = Post.all

    if params[:sort] == "Ruby"
      @posts = Category.find_by(:name =>"Ruby").posts.where(:draft => false).page(params[:page]).per(5)
    elsif params[:sort] == "Perl"
      @posts = Category.find_by(:name =>"Perl").posts.where(:draft => false).page(params[:page]).per(5)
    elsif params[:sort] == "Java"
      @posts = Category.find_by(:name =>"Java").posts.where(:draft => false).page(params[:page]).per(5)
    else
      @posts = Post.all.order("updated_at DESC").where(:draft => false).page(params[:page]).per(5)
    end


    if params[:order]
      if params[:order] == 'last_comment_time'
        @posts = Post.all.order("comment_last_updated_at DESC").where(:draft => false).page(params[:page]).per(5)
      elsif params[:order] && params[:order] == 'comment_number'
        @posts = Post.all.order("comments_count DESC").where(:draft => false).page(params[:page]).per(5)
      elsif params[:order] && params[:order] == "topic_clicks"
        @posts = Post.all.order("clicked DESC").where(:draft => false).page(params[:page]).per(5)
      end
    end


    # if current_user.nil?
    #   @posts = @posts.where(:draft=>"false")
    # else
    #   @posts = @posts.where("user_id =? or draft=?", current_user.id,"false")
    # end

    # @categories = Category.all

  end

  def show
    @post.clicked += 1
    @post.save

    # @comments = @post.comments.order("updated_at desc")
    if current_user.nil?
      @comments = @post.comments.where(:draft=>"false").order("updated_at desc")
    else
      @comments = @post.comments.where("user_id =? or draft=?", current_user.id,"false").order("updated_at desc")
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.author = current_user

    if @post.save
      flash[:notice] = "Post was successfully created"
      redirect_to :action => :index
    else
      render :action => :new
    end
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_params)
      flash[:notice] = "Update successfully"
      redirect_to :action => :index
    else
      render :action => :edit
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy
    redirect_to posts_path :action => :index
    flash[:alert] = "The post was successfully deleted"
  end

  def about
    @users = User.all
    @posts = Post.all
    @comments = Comment.all
  end

  protected

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :clicked, :draft, :category_ids => [])
  end
end
