class CommunityServicesController < ApplicationController
  before_action :select_service, only: [:show, :edit, :destroy, :update]
  def new
    @community_service = CommunityService.new
  end

  def create
    @community_service = CommunityService.new(community_service_params)
    if current_user
      if @community_service.address.blank?
        @community_service.address = ChinaCity.get(params[:province]) + ChinaCity.get(params[:city]) + ChinaCity.get(params[:area]) + params[:detail_address]
        community_name = params[:new_community]
        if Community.find_by(name: community_name).nil?
          new_community = Community.create name: community_name, area: (ChinaCity.get(params[:province]) + ChinaCity.get(params[:city]) + ChinaCity.get(params[:area])), address: params[:detail_address]
          @community_service.community_id = new_community.id
        end
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
    @community_services = CommunityService.all
    set_scope @community_services
  end

  def secondhand_info
    @community_services = CommunityService.esxx
    set_scope @community_services
  end

  def household_service
    @community_services = CommunityService.jzfw
    set_scope @community_services
  end

  def house_rental_and_sale
    @community_services = CommunityService.fwzs
    set_scope @community_services
  end

  def convenience_info
    @community_services = CommunityService.bmxx
    set_scope @community_services
  end

  def edit
    @method = 'patch'
    @photos = @community_service.photos
  end

  def update
    if @community_service.update(community_service_params)
      if @community_service.address.blank?
        @community_service.address = ChinaCity.get(params[:province]) + ChinaCity.get(params[:city]) + ChinaCity.get(params[:area]) + params[:detail_address]
      end
      if @community_service.save
        if params[:images]
          params[:images].each do |image|
            @community_service.photos.update(image: image)
          end
        end
        # 删除与团购关联的图片
        origin_ids = @community_service.photos.pluck(:id)
        if params[:photo_ids].present? || params[:delete_ids].present?
          ids = params[:photo_ids].split(',').select(&:present?)
          Photo.where(id: ids).update_all(community_service_id: params[:id])

          Rails.logger.info origin_ids
          Rails.logger.info '###############'
          Rails.logger.info params[:delete_ids]
          if params[:delete_ids].present?
            delete_ids = params[:delete_ids].split(',').select(&:present?)
            Photo.where(id: delete_ids).update_all(community_service_id: nil)
          end
        end
        redirect_to community_service_path(@community_service)
      else
        render 'edit'
      end
    else
      render 'edit'
    end
  end

  def destroy
    @community_service.destroy
    redirect_to community_services_path
  end

  private

  def select_service
    @community_service = CommunityService.find_by(id: params[:id])
  end

  def community_service_params
    params.require(:community_service).permit(:user_id, :title, :content, :community_id, :tag, :address)
  end

  def set_scope services
    @with = ''
    @order_by = ''
    if current_user && current_user.my_services?
      if params[:order_by].present? && params[:with].present?
        @order_by = params[:order_by]
        @with = params[:with]
        if @order_by == 'name'
          @community_services = services.joins(:user, :community).where('community_services.community_id = ?', current_user.community.id).order("communities.name #{@with}")
        else
          @community_services = services.joins(:user).where('community_services.community_id = ?', current_user.community.id).order("#{params[:order_by]} #{params[:with]}")
        end
      else
        @community_services = services.joins(:user).where('community_services.community_id = ?', current_user.community.id).desc
      end
    else
      if params[:order_by].present? && params[:with].present?
        @order_by = params[:order_by]
        @with = params[:with]
        if @order_by == 'name'
          @community_services = services.joins(:community).order("communities.name #{@with}")
        else
          @community_services = services.order("#{params[:order_by]} #{params[:with]}")
        end
      else
        @community_services = services.desc
      end
    end
  end
end
