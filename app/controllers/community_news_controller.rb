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
        photo_ids = params[:photo_ids].split(',')
        Photo.where(id: photo_ids).update_all(community_news_id: @community_news.id)
        redirect_to @community_news
      else
        render 'new'
      end
    end
  end

  def show
    @community_news = CommunityNews.find_by(id: params[:id])
    @photos = @community_news.photos
  end

  def index
    if current_user && current_user.my_news?
      @billboards = CommunityNews.joins(:user).where('community_news.community_id = ?', current_user.community.id).billboards
      @notices = CommunityNews.joins(:user).where('community_news.community_id = ?', current_user.community.id).notices
      @activities = CommunityNews.joins(:user).where('community_news.community_id = ?', current_user.community.id).activities
    else
    @billboards = CommunityNews.billboards
    @notices = CommunityNews.notices
    @activities = CommunityNews.activities
  end
  end

  private

  def community_news_params
    params.require(:community_news).permit(:user_id, :title, :content, :community_id, :tag)
  end
end
