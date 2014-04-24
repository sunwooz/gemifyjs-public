class User < ActiveRecord::Base
  has_many :jems
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :omniauth_providers => [:github]

  def self.find_for_github_oauth(auth)
    where(:email => auth["info"]["email"]).first_or_create do |user|
      user.email = auth.info.email
      user.name = auth.info.name
    end
  end

end
