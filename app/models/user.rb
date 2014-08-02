class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
            :recoverable, :rememberable, :trackable, :validatable

    has_many :contents
    has_many :tags
    has_many :students

    validates :email, :presence => true, :uniqueness => true

    # def self.current
    #     Thread.current[:user]
    # end

    # def self.current=(user)
    #     Thread.current[:user] = user
    # end

end
