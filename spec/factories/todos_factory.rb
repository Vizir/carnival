FactoryGirl.define do
  factory :todo do
    sequence(:title) { |n| "Titlte #{n}" }

    trait :todo do
      status :todo
    end

    trait :doing do
      status :doing
    end

    trait :done do
      status :done
    end
  end
end
