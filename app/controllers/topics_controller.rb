class TopicsController < ApplicationController
  def new
    @topic = Topic.new
  end

  def show
    @topic = Topic.find_by(id: params[:id])
  end

  def create
    @topic = Topic.new(topic_params)
    if current_user
      if @topic.save
        redirect_to @topic
      else
        render 'new'
      end
    end
  end

  def index
    @with = ''
    @order_by = ''
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

  private

  def topic_params
    params.require(:topic).permit(:title, :content, :user_id, :community_id)
  end
end
