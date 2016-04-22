class Community < ActiveRecord::Base
  has_many :users
  has_many :community_news
  has_many :community_services
  has_many :topics
  validates :name, uniqueness: true
end
