class ActivitiesController < ApplicationController
  before_action :autheorize_admin!, only: [:new, :create, :edit, :update, :destroy]
  before_action :select_activity, only: [:show, :edit]
  def new
    @activity = Activity.new
  end

  def create
    activity = Activity.new(activity_params)
    if activity.save
      redirect_to activity_path(activity)
    else
      render 'new'
    end
  end

  def index
    @activities = Activity.all
  end

  def show
  end

  private

  def activity_params
    params.require(:activity).permit(:title, :location, :start_time, :introduction, :extras_info, :for_free, :sponsor)
  end

  def select_activity
    @activity = Activity.find_by(id: params[:id])
  end
end
