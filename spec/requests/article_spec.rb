require 'rails_helper'

RSpec.describe ArticlesController do
  describe '#index action' do
    it 'should return success status code' do
      get '/articles'
      expect(response).to have_http_status(:ok)
      expect(response.status).to eq(200)
    end

    it 'should return a proper JSON format' do
      article = create :article
      get '/articles'
      expect(json_data.length).to eq(1)
      expected = json_data.first
      aggregate_failures do
        expect(expected[:id]).to eq(article.id.to_s)
        expect(expected[:type]).to eq('article')
        expect(expected[:attributes]).to eq(
          title: article.title,
          content: article.content,
          slug: article.slug
        )
      end
    end
  end
end