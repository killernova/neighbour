class CommunityService < ActiveRecord::Base
  belongs_to :user
  belongs_to :community
  scope :desc, -> { order(created_at: :desc) }
end
