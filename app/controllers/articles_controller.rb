class ArticlesController < ApplicationController
  include Paginable

  def index
    articles = Article.recent
    paginated = paginate(articles)
    render_collection(paginated)
  end

  def show
    article = Article.find params[:id]
    render json: serializer.new(article)
  end

  private
  def serializer
    ArticleSerializer
  end
end