require 'convert_picture'
class CommunityService < ActiveRecord::Base
  include ConvertPicture
  belongs_to :user
  belongs_to :community
  has_many :photos
  has_many :comments
  before_save :set_tag
  scope :desc, -> { order(created_at: :desc) }

  def set_tag
    if tag.blank?
      self.tag = '其他'
    end
  end

  def list_pic
    other_img (self.photos.try :first), 'mini'
  end
end
