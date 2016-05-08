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

  def tag_name
    case tag
    when 'esxx' then '二手信息'
    when 'jzfw' then '家政服务'
    when 'fwzs' then '房屋租售'
    when 'bmxx' then '便民信息'
    end
  end
end
