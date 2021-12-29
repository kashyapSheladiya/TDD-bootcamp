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

    it 'should return articles in proper order' do
      older_article = create(:article, created_at: 1.hour.ago)
      newer_article = create(:article)
      get '/articles'
      ids = json_data.map { |item| item[:id].to_i }
      expect(ids).to eq([newer_article.id, older_article.id])
    end

    it 'paginates result' do
      article1, article2, article3 = create_list(:article, 3)
      get '/articles', params: { page: { number: 3, size: 1} }
      expect(json_data.length).to eq(1)
      expect(json_data.first[:id]).to eq(article1.id.to_s)
    end

    it 'contains pagination link in the response' do
      article1, article2, article3 = create_list(:article, 3)
      get '/articles', params: { page: { number: 2, size: 1} }
      
      expect(json[:links].length).to eq(5)
      expect(json[:links].keys).to contain_exactly(:first, :prev, :next, :last, :self)

      get '/articles', params: { page: { number: 3, size: 1} }
      expect(json[:links].length).to eq(3)
      expect(json[:links].keys).to contain_exactly(:first, :prev, :self)

      get '/articles', params: { page: { number: 1, size: 1} }
      expect(json[:links].length).to eq(3)
      expect(json[:links].keys).to contain_exactly(:next, :last, :self)
    end


  end

  describe '#show action' do
    let(:article) { create :article }

    subject { get "/articles/#{article.id}" }

    before { subject }
    it 'should return a success status' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns a proper JSON' do
      aggregate_failures do
        expect(json_data[:id]).to eq(article.id.to_s)
        expect(json_data[:type]).to eq('article')
        expect(json_data[:attributes]).to eq(
          title: article.title,
          content: article.content,
          slug: article.slug
        )
      end
    end
  end
end