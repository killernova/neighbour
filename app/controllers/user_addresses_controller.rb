#encoding:utf-8
class UserAddressesController < ApplicationController
  before_action :validate_user!
  before_action only: [:show, :edit, :update, :destroy] do
    validate_permission!(set_user_address.user)
  end
  before_action :set_user_address, only: [:edit, :update, :destroy]

  def new
    @user_address = UserAddress.new
  end

  def create
    if params[:province] && params[:city] && params[:area]
      area = [ChinaCity.get(params[:province]), ChinaCity.get(params[:city]), ChinaCity.get(params[:area])].join('/')
      address = ChinaCity.get(params[:province]) + ChinaCity.get(params[:city]) + ChinaCity.get(params[:area])+ user_address_params[:address]
    end
    @user_address = UserAddress.new(user_address_params)
    @user_address.address = address
    @user_address.area = area
    @user_address.user = current_user
    Rails.logger.info user_address_params
    if@user_address.save
      if params[:default] == '1'
        user_address = UserAddress.where(default: 1)
        if user_address.present?
          user_address.first.update(default: 0)
        end
        @user_address.update(default: 1)
      end
      
      return_url = session[:return_url]
      if return_url
        session[:return_url] = nil
        return redirect_to return_url
      end

      if params[:groupbuy_id]
        return redirect_to groupbuy_path(params[:groupbuy_id])
      end

      redirect_to user_addresses_path, notice: '地址添加成功'
    else
      render :new
    end
  end

  def show
    @user_address = UserAddress.find(params[:id])
  end

  def edit()
  end

  def update
    if params[:province] && params[:city] && params[:area]
      area = [ChinaCity.get(params[:province]), ChinaCity.get(params[:city]), ChinaCity.get(params[:area])].join('/')
      address = ChinaCity.get(params[:province]) + ChinaCity.get(params[:city]) + ChinaCity.get(params[:area])+ user_address_params[:address]
    end
    if params[:from] == 'ajax'
      user_address = UserAddress.where(default: 1)
      if user_address.present?
        user_address.first.update(default: 0)
      end
      UserAddress.find(params[:id]).update(default: 1)
      return render text: 'success'
    end

    if @user_address.update(user_address_params)
      @user_address.update(address: address)
      @user_address.update(area: area)
      Rails.logger.info '########' + @user_address.default.to_s
      if params[:default] == '1' && @user_address.default == 0
        user_address = UserAddress.where(default: 1)
        if user_address.present?
          user_address.first.update(default: 0)
        end
        @user_address.update(default: 1)
      end

      return_url = session[:return_url]
      Rails.logger.info '#################' + return_url.to_s
      if return_url
        session[:return_url] = nil
        return redirect_to return_url
      end
      redirect_to user_addresses_path(groupbuy_id: params[:groupbuy_id]), notice: '地址修改成功'
    else
      render :edit
    end
  end

  def destroy
   @user_address.destroy
   respond_to do |format|
    format.html {redirect_to user_addresses_path, notice: '地址删除成功'}
    format.js
  end
end

def index
  if params[:groupbuy_id]
    @groupbuy_id = params[:groupbuy_id]
    #session[:return_url]= groupbuy_path(params[:groupbuy_id])
    params.delete(:groupbuy_id)
    Rails.logger.info @groupbuy_id
  end
  @user_addresses = current_user.user_addresses
  @user_address = UserAddress.new
end

private
def set_user_address
  @user_address = UserAddress.find(params[:id])
end

def user_address_params
  params.require(:user_address).permit(:name, :address, :mobile, :area, :default)
end
end
