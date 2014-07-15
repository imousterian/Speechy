# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :content do
    type ""
    is_public false
    dblink "MyString"
    user_id 1
  end
end
