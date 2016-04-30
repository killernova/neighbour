class User < ActiveRecord::Base
  has_secure_password
  enum show_all_news: [:my_news, :all_news]
  enum show_all_services: [:my_services, :all_services]
  enum show_all_topics: [:my_topics, :all_topics]

  has_many :topics,   dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :participants, dependent: :destroy

  has_many :user_interests, dependent: :destroy
  has_many :user_addresses, dependent: :destroy
  belongs_to :community
  has_many :community_news
  has_many :community_services, dependent: :destroy
  after_create :set_default_range

  def set_default_range
    update(show_all_news: 1, show_all_topics: 1, show_all_services: 1)
  end

  def member?
    self.role == '0'
  end

  def super_admin?
    self.role == '1'
  end

  def normal_admin?
    self.role == '2'
  end



  #validates :username,   presence:   true,
  #uniqueness: { case_sensitive: false },
  #length:     { in: 2..40 }
                         #,format:     { with: /\A[a-zA-Z][a-zA-Z0-9_-]*\Z/ }
                        # ,exclusion:  { in: ['oturum_ac'] }

                        #validates :mobile,    presence:   true,
                        #uniqueness: { case_sensitive: false }

  # validates :email,      presence:   true,
  #                        uniqueness: { case_sensitive: false },
  #                        email:      true

  #validates :terms_of_service, acceptance: { accept: 'yes' }


  def to_param
    username
  end

  def default_address
    user_addr = self.user_addresses.find_by(default: 1)
    {mobile: user_addr.present? ? user_addr.mobile : self.mobile, address: user_addr.present? ? user_addr.address : self.location}
  end
end
