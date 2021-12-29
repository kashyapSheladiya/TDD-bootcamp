class ArticlesController < ApplicationController
  include Paginable
  
  def index
    articles = Article.recent
    paginated = paginate(articles)
    render_collection(paginated)
  end

  private
  def serializer
    ArticleSerializer
  end
end