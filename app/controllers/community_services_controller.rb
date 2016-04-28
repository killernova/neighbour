class CommunityServicesController < ApplicationController


  def new
    @community_service = CommunityService.new
  end

  def create
    @community_service = CommunityService.new(community_service_params)
    if current_user
      if @community_service.save
        photo_ids = params[:photo_ids].split(',')
        Photo.where(id: photo_ids).update_all(community_service_id: @community_service.id)
        redirect_to @community_service
      else
        render 'new'
      end
    end
  end

  def show
    @parent = @community_service = CommunityService.includes(:photos, :comments, :user).find_by(id: params[:id])
    @photos = @community_service.photos
    @comments = @community_service.comments.includes(:user)
    @comment = @community_service.comments.new
  end

  def index
    @with = ''
    @order_by = ''
    if params[:order_by].present? && params[:with].present?
      @order_by = params[:order_by]
      @with = params[:with]
      if @order_by == 'name'
        @community_services = CommunityService.joins(:community).order("communities.name #{@with}")
      else
        @community_services = CommunityService.order("#{params[:order_by]} #{params[:with]}")
      end
    else
      @community_services = CommunityService.desc
    end
  end


  private

  def community_service_params
    params.require(:community_service).permit(:user_id, :title, :content, :community_id, :tag)
  end
end
