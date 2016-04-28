class Photo < ActiveRecord::Base
  belongs_to :community_news
  belongs_to :community_service
  belongs_to :comment
  belongs_to :topic
  # mount_uploader :image, PictureUploader
  include Rails.application.routes.url_helpers

  def to_jq_upload
    {
      'name'        => read_attribute(:name),
      'size'        => read_attribute(:size),
      'url'         => image_url,
      'small_url'   => image_url(:small),
      'delete_url'  => photo_path(self),
      'delete_type' => 'DELETE'
    }
  end

  private
end
