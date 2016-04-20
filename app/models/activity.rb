class Activity < ActiveRecord::Base
  has_many :photos, dependent: :destroy
  validates :title, length: { in: 6..20 }
  validates :introduction, length: { in: 10..5000 }
  validates :location, :start_time, :for_free, presence: true
end
