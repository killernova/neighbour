class CommunityNewsController < ApplicationController
  before_action :authorize_or_admin!, only: [:new, :create]
  before_action :autheorize_special_admin!, only: [:edit, :update, :destroy]

  def new
    @community_news = CommunityNews.new
  end

  def create
    @community_news = CommunityNews.new(community_news_params)
    if current_user
      if @community_news.save
        redirect_to @community_news
      else
        render 'new'
      end
    end
  end

  def show
    @community_news = CommunityNews.find_by(id: params[:id])
  end

  def index
    @billboards = CommunityNews.billboards
    @notices = CommunityNews.notices
    @activities = CommunityNews.activities
  end

  private

  def community_news_params
    params.require(:community_news).permit(:user_id, :title, :content, :community_id, :tag)
  end
end
