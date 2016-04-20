module SessionsHelper
  def is_admin?
    current_user.try(:role) == '1'
  end

  def is_community_admin?
    current_user.try(:role) == '2'
  end

  def is_or_admin?
    current_user.try(:role).in? ['1', '2']
  end

  def authorize_or_admin!
    redirect_to root_path unless is_or_admin?
  end

  def authorize_community_admin!
    redirect_to root_path unless is_community_admin?
  end

  def autheorize_admin!
    redirect_to root_path unless is_admin?
  end

  def autheorize_special_admin!
    redirect_to root_path unless is_admin? || (is_community_admin? && community_news_by(current_user))
  end
end
