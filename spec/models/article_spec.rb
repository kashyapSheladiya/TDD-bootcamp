require 'rails_helper'

RSpec.describe Article, type: :model do
  describe '#validations' do
    let(:article) { create(:article) }
    it 'tests the valid article object' do
      expect(article).to be_valid
      article2 = build(:article)
      expect(article2).to be_valid
    end

    it 'checks title is valid' do
      article.title = ''
      expect(article).not_to be_valid
      expect(article.errors[:title]).to include "can't be blank"
      expect(article.errors.count).to be > 0
    end

    it 'has an invalid content' do
      article.content = ''
      expect(article).not_to be_valid
      expect(article.errors[:content]).to include "can't be blank"
    end

    it 'has an invalid slug' do
      article.slug = ''
      expect(article).not_to be_valid
      expect(article.errors[:slug]).to include "can't be blank"
    end

    it 'tests an uniqueness of slug' do
      article1 = article
      article2 = build(:article, slug: article1.slug)
      expect(article1).to be_valid
      expect(article2).not_to be_valid
      expect(article2.errors[:slug]).to include "has already been taken"
    end
  end

  describe '.recent' do
    it 'should return article in proper order' do
      older_article = create(:article, created_at: 1.hour.ago)
      newer_article = create(:article)

      expect(described_class.recent).to eq([newer_article, older_article])

      newer_article.update_column(:created_at, 2.hours.ago )
      expect(described_class.recent).to eq([older_article, newer_article])
    end
  end
end
