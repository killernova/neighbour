#encoding:utf-8
class CommentsController < ApplicationController
  before_action :validate_user!

  before_action only: [:edit, :update, :destroy] do
    validate_permission!(select_comment.user)
  end

  before_action :select_comment, only: [:edit, :update, :destroy]

  before_action only: [:new, :create,:index, :destroy] do
    const = params[:controller].classify.constantize
    @parent = const.find_by(id: params[:id])
  end


  def new
    @comment = @parent.comments.new
  end

  def create
    @parent = params[:comment_parent].classify.constantize.find_by(id: params[:parent_id])
    @comment = @parent.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      photo_ids = params[:photo_ids].split(',')
      Photo.where(id: photo_ids).update_all(comment_id: @comment.id)
      if @comment.topic
        @url = topic_path(@comment.topic)
      elsif @comment.community_service
        @url = community_service_path(@comment.community_service)
      elsif @comment.community_news
        @url = community_news_path(@comment.community_news)
      end
      notice = '添加评论成功'
      redirect_to @url, notice: notice
    else
      render :new
    end
  end

  def edit
    @photos = @comment.photos
  end

  def update
      # 删除与评论关联的图片
    origin_ids = @comment.photos.pluck(:id)
    if params[:photo_ids].present? || params[:delete_ids].present?
      ids = params[:photo_ids].split(',').select{|id|id.present?}
      Photo.where(id: ids).update_all(comment_id: params[:id])

      Rails.logger.info origin_ids
      Rails.logger.info '###############'
      Rails.logger.info params[:delete_ids]
      if params[:delete_ids].present?
        delete_ids = params[:delete_ids].split(',').select{|id|id.present?}
        Photo.where(id: delete_ids).update_all(comment_id: nil)
      end
    end

    if @comment.update(comment_params)
      notice = '修改评论成功'
      if @comment.topic
        redirect_to topic_url(@comment.topic), notice: notice
      elsif @comment.event
        redirect_to event_url(@comment.event), notice: notice
      elsif @comment.groupbuy
        redirect_to groupbuy_url(@comment.groupbuy), notice: notice
      end
    else
      render :edit
    end
  end

  def destroy

    @comment.destroy
    notice = '删除评论成功'
    @comment.community_service || @comment.topic || @comment.community_news
    if @comment.topic
      redirect_to topic_path(@comment.topic), notice: notice
    elsif @comment.community_service
     redirect_to community_service_path(@comment.community_service), notice: notice
   elsif @comment.community_news
    redirect_to community_news_path(@comment.community_news), notice: notice
    end
  end

def index
  @comment = @parent.comments.new
  @comments = @parent.comments.includes(:user).limit(3)
  render layout: nil
end

def more_comments
  elements = []
  parent = params[:parent]
  start = params[:start].to_i
  over = params[:over].to_i
  comments = parent.constantize.includes(:forum, :comments, :user).find(params[:id]).comments.includes(:user)[start...over]
  comments.each do |comment|
    elements << "<div class='row small-collapse'><div  class='columns small-12 comment'>" << comment.body.html_safe if comment.body << view_context.comment_info(comment) << "</div></div>"
  end
  elements = elements.join
  return render text: elements
end




private

def select_comment
  @comment = Comment.find(params[:id])
end

def comment_params
  params.require(:comment).permit(:body)
end
end
