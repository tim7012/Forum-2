module Admin::CategoriesHelper

  def category_used?(category)
    category.posts.size == 0? false : true
  end
end
