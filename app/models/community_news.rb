class CommunityNews < ActiveRecord::Base
  belongs_to :user
  belongs_to :community
  has_many :photos
  scope :billboards, -> { where(tag: 'billboard').order(updated_at: :desc) }
  scope :notices, -> { where(tag: 'notice').order(updated_at: :desc) }
  scope :activities, -> { where(tag: 'activity').order(updated_at: :desc) }

  def community_news_by user
    user_id == user.id
  end
end
