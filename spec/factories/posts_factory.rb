FactoryGirl.define do
  factory :post do
    sequence(:title) { |n| "Title #{n}" }
    sequence(:content) { |n| "Content #{n}" }
  end
end
