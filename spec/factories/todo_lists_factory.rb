FactoryGirl.define do
  factory :todo_list do
    sequence(:name) { |n| "Name #{n}" }
  end
end
