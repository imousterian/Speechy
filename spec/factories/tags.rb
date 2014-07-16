# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tag do
    tagname "MyString"
    content_id 1
  end
end
