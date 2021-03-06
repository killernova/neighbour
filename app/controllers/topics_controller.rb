class TopicsController < ApplicationController
  before_action :set_topic, only: [:edit, :update, :show, :destroy]
  def new
    @topic = Topic.new
  end

  def show
    @parent = @topic = Topic.includes(:photos, :comments, :user).find_by(id: params[:id])
    @photos = @topic.photos
    @comments = @topic.comments.includes(:user)
    @comment = @topic.comments.new
  end

  def create
    @topic = Topic.new(topic_params)
    if current_user
      if @topic.save
        photo_ids = params[:photo_ids].split(',')
        Photo.where(id: photo_ids).update_all(topic_id: @topic.id)
        redirect_to @topic
      else
        render 'new'
      end
    end
  end

  def index
    @with = ''
    @order_by = ''
    if current_user && current_user.my_topics?
      if params[:order_by].present? && params[:with].present?
        @order_by = params[:order_by]
        @with = params[:with]
        if @order_by == 'name'
          @topics = Topic.joins(:user, community).where('topics.community_id = ?', current_user.community.id).order("communities.name #{@with}")
        else
          @topics = Topic.joins(:user).where('topics.community_id = ?', current_user.community.id).order("#{params[:order_by]} #{params[:with]}")
        end
      else
        @topics = Topic.joins(:user).where('topics.community_id = ?', current_user.community.id).desc
      end
    else
    if params[:order_by].present? && params[:with].present?
      @order_by = params[:order_by]
      @with = params[:with]
      if @order_by == 'name'
        @topics = Topic.joins(:community).order("communities.name #{@with}")
      else
        @topics = Topic.order("#{params[:order_by]} #{params[:with]}")
      end
    else
      @topics = Topic.desc
    end
  end
  end

  def edit
    @method = 'patch'
    @photos = @topic.photos
  end

  def update
    if @topic.update(topic_params)
      if params[:images]
        params[:images].each do |image|
          @topic.photos.update(image: image)
        end
      end
    # 删除与团购关联的图片
    origin_ids = @topic.photos.pluck(:id)
    if params[:photo_ids].present? || params[:delete_ids].present?
      ids = params[:photo_ids].split(',').select(&:present?)
      Photo.where(id: ids).update_all(topic_id: params[:id])

      Rails.logger.info origin_ids
      Rails.logger.info '###############'
      Rails.logger.info params[:delete_ids]
      if params[:delete_ids].present?
        delete_ids = params[:delete_ids].split(',').select(&:present?)
        Photo.where(id: delete_ids).update_all(topic_id: nil)
      end
    end
      redirect_to topic_path(@topic)
    else
      render 'edit'
    end
  end

  def destroy
    @topic.destroy
    redirect_to topics_path
  end

  private

  def set_topic
    @topic = Topic.find_by(id: params[:id])
  end

  def topic_params
    params.require(:topic).permit(:title, :content, :user_id, :community_id)
  end
end
