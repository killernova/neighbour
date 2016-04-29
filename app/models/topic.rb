require 'convert_picture'
class Topic < ActiveRecord::Base
  include ConvertPicture
  belongs_to :user
  belongs_to :community
  has_many :photos
  has_many :comments
  scope :desc, -> { order(created_at: :desc) }

  def list_pic
    other_img (self.photos.try :first), 'mini'
  end
end
