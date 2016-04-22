#encoding:utf-8
class UsersController < ApplicationController
  before_action :select_user, only: [:show, :edit, :update, :destroy, :user_info, :my_orders]
  before_action only: [:edit, :update, :destroy] do
    validate_permission!(select_user)
  end
  
  def index
  end

  def new
    if session[:openid].present?
      user = User.where(weixin_openid: session[:openid])
      if user.present?
        login(user.first)
        if return_url = params[:return_url]
          return redirect_to return_url
        end
      end
    end
    @user = User.new
    
  end

  def my_community_services
    @my_community_services = current_user.try(:community_services)
  end

  def my_topics
    @my_topics = current_user.try(:topics)
  end

  def create
    if user_params[:password].nil?
      user_params[:password] = user_params[:mobile]
      user_params[:username] = user_params[:mobile]
    end

    redirect_url = session[:return_url].present? ? session[:return_url] : root_url
    # 绑定新的公众号
    if user = User.find_by(mobile: user_params[:mobile])
      user.update(weixin_openid: session[:openid], nickname: session[:nickname], avatar: session[:avatar])
      login user
      session[:mobile] = user.mobile
      
      session.delete(:return_url)
      return redirect_to redirect_url
    end

    @user = User.new(user_params)
    @user.weixin_openid = session[:openid]
    @user.avatar = session[:avatar]
    @user.nickname = session[:nickname]
    if params[:from] == 'share_from_foodie'
      @user.weixin_openid = params[:openid]
      @user.avatar = params[:avatar]
      @user.nickname = params[:nickname]
      @user.group_id = params[:group_id]
    end

    if @user.save
      login(@user)
      session[:mobile] = @user.mobile
      if params[:return_url]
        return redirect_to URI.decode(params[:return_url])
      else
        return redirect_to redirect_url, notice: '注册成功!'
      end
    else
      render :new
    end
  end

  def show

    #微信share接口配置
    if current_user.present?



      @title = session[:locale] == 'zh' ? "推荐您加入 Groupmall!" : "recommend you to join Groupmall!"
      @img_url = 'http://ljt.trade-v.com/groupmall_logo.jpg'
      @desc = session[:locale] == 'zh' ? 'Groupmall 是拼人品的团购、聚会和论坛。' : 'Groupmall is trusted based group buying, meetups and forums.'
      @timestamp = Time.now.to_i
      @appId = WX_APP_ID
      @noncestr = random_str 16
      @jsapilist = ['onMenuShareTimeline', 'onMenuShareAppMessage', 'onMenuShareQQ', 'onMenuShareWeibo', 'onMenuShareQZone']
      @jsapi_ticket = get_jsapi_ticket
      post_params = {
        :noncestr => @noncestr,
        :jsapi_ticket => @jsapi_ticket,
        :timestamp => @timestamp,
        :url => request.url.gsub("localhost:5000", "ljt.trade-v.com")
      }
      @sign = create_sign_for_js post_params
      @a = [request.url, post_params, request.url.gsub("trade", "ljt.trade-v.com")]
    end

    type = params[:type] || 'topic'
    
    
    @share_alert = session[:locale] == 'zh' ? '请点击右上角的分享按钮进行分享' : 'Please click the SHARE BUTTON on the top right conner'
    render layout: "profile2", locals: {page: type}
  end


  def contact_us
  end

  def user_info
    case @user.sex
    when '0'
      @sex = 'unknown'
    when '1'
      @sex = 'male'
    when '2'
      @sex = 'female'
    end
  end

  def my_orders
    @orders = Participant.includes(:groupbuy).where('user_id = ? AND groupbuy_id > ?', current_user.id, 0 ).order(created_at: :desc)
  end

  def edit
  end

  def update
    uploaded_io = params[:file]

    if !uploaded_io.blank?
      extension = uploaded_io.original_filename.split('.')
      filename = "#{Time.now.strftime('%Y%m%d%H%M%S')}.#{extension[-1]}"
     # filepath = "#{PIC_PATH}/teachResources/devices/#{filename}"
     filepath = "#{PIC_PATH}/avatars/#{filename}"
     File.open(filepath, 'wb') do |file|
      file.write(uploaded_io.read)
    end
    user_params.merge!(:avatar=>"/avatars/#{filename}")
  end

  update_params = user_params

  if update_params.has_key?(:password)
    update_params.delete([:password, :password_confirmation])
  end

  if @user.update(update_params)
    redirect_to profile_url(@user), notice: '个人信息修改成功'
  else
    render :edit, layout: "profile"
  end
end

def add_info
  user = User.find_by(id: params[:user_id])
  begin
    community = Community.find_or_initialize_by(name: params[:community_name])
  rescue ActiveRecord::RecordNotUnique
    retry
  end
  if community.save
    user.update(mobile: params[:mobile], community_id: community.id, location: params[:location])
    @result = {msg: 'ok'}
    @url = params[:to_url]
  else
    @result = {msg: 'failed', msg_detail: "can not create or find certain community with name of #{params[:community_name]} "}
  end
end

def destroy
  logout
  @user.destroy
  redirect_to root_url
end

private

def user_params
  params.require(:user).permit!
end

def select_user
  @user = User.find_by(id: params[:id])
end

end
