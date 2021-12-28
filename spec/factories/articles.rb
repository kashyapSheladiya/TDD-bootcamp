FactoryBot.define do
  factory :article do
    title { "Sample title" }
    content { "Sample content" }
    sequence(:slug) { |n| "sample-title-#{n}"}
  end
end
