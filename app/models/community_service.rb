require 'convert_picture'
class CommunityService < ActiveRecord::Base
  include ConvertPicture
  belongs_to :user
  belongs_to :community
  has_many :photos
  has_many :comments
  scope :desc, -> { order(created_at: :desc) }
  enum tag: [:esxx, :jzfw, :fwzs, :bmxx]
  scope :esxx, -> { where(tag: 0) }
  scope :jzfw, -> { where(tag: 1) }
  scope :fwzs, -> { where(tag: 2) }
  scope :bmxx, -> { where(tag: 3) }


  def list_pic
    other_img (self.photos.try :first), 'mini'
  end
end
