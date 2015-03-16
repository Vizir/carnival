FactoryGirl.define do
  factory :todo do
    sequence(:title) { |n| "Titlte #{n}" }
  end
end
