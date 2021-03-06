class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
            :recoverable, :rememberable, :trackable, :validatable

    has_many :contents, :dependent => :destroy
    has_many :tags
    has_many :students, :dependent => :destroy

    validates :email, :presence => true, :uniqueness => true

    def guest?
        self.guest
    end

    def admin?
        self.admin
    end

end
