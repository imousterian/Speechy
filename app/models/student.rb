class Student < ActiveRecord::Base
    belongs_to :user

    validates :name, :presence => true, :uniqueness => true
end
