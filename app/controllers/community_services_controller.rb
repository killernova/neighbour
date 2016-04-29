class CommunityServicesController < ApplicationController


  def new
    @community_service = CommunityService.new
  end

  def create
    @community_service = CommunityService.new(community_service_params)
    if current_user
      if @community_service.address.blank?
        @community_service.address = ChinaCity.get(params[:province]) + ChinaCity.get(params[:city]) + ChinaCity.get(params[:area]) + params[:detail_address]
      end
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
    @address = @community_service.address
    @onload = 'geocoder()'
  end

  def index
    @with = ''
    @order_by = ''
    if current_user && current_user.my_services?
      if params[:order_by].present? && params[:with].present?
        @order_by = params[:order_by]
        @with = params[:with]
        if @order_by == 'name'
          @community_services = CommunityService.joins(:user, :community).where('community_services.community_id = ?', current_user.community.id).order("communities.name #{@with}")
        else
          @community_services = CommunityService.joins(:user).where('community_services.community_id = ?', current_user.community.id).order("#{params[:order_by]} #{params[:with]}")
        end
      else
        @community_services = CommunityService.joins(:user).where('community_services.community_id = ?', current_user.community.id).desc
      end
    else
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
  end


  private

  def community_service_params
    params.require(:community_service).permit(:user_id, :title, :content, :community_id, :tag, :address)
  end
end
