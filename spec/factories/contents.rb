# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :content do
    is_public false
    dblink "MyString"
    user_id 1
    image { File.new(Rails.root.join('app/assets/images/carousel-arrow-left-hover.png')) }
  end
end
