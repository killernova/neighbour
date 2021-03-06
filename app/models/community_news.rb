require 'convert_picture'
class CommunityNews < ActiveRecord::Base
  include ConvertPicture
  belongs_to :user
  belongs_to :community
  has_many :photos
  scope :billboards, -> { where(tag: 'billboard').order(updated_at: :desc) }
  scope :notices, -> { where(tag: 'notice').order(updated_at: :desc) }
  scope :activities, -> { where(tag: 'activity').order(updated_at: :desc) }

  def community_news_by user
    user_id == user.id
  end

  def list_pic
    other_img (self.photos.try :first), 'mini'
  end
end
