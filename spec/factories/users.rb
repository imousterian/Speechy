# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
    factory :user do
        email "fidel@awesome.com"
        password "foobar22"
        password_confirmation "foobar22"
    end
end
