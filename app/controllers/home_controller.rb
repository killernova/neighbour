#encoding:utf-8
class HomeController < ApplicationController
	before_action {@forums = Forum.all}
  before_action :login_with_mobile

	def index
		#微信入口页面

		Rails.logger.info "---------------------------#{session[:openid]}"
    Rails.logger.info "---------------------------#{session[:mobile]}"
    Rails.logger.info "---------------------------#{current_user.try(:nickname)}"
	end

  def drag_drop
  end

  def about_groupmall
  end

  private
  def login_with_mobile
    if session[:mobile].present?
      user = User.find_by(mobile: session[:mobile])
      login user
    end
  end
end
