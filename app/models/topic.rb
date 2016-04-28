class Topic < ActiveRecord::Base
  belongs_to :user
  belongs_to :community
  has_many :photos
  has_many :comments
  scope :desc, -> { order(created_at: :desc) }
end
