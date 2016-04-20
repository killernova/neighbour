class Community < ActiveRecord::Base
  has_many :users
  has_many :community_news

end
