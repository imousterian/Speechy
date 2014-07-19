class Tag < ActiveRecord::Base
    has_many :taggings
    has_many :contents, through: :taggings
    belongs_to :user
end
