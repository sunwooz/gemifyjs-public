class StaticController < ApplicationController

  skip_before_action :authenticate_user!
  
  def index
    render layout: false
  end

  def show
    @jems = Jem.all
    @users_count = User.all.length
    @scripts_count = Script.all.length
    @activities = Activity.all.order("created_at desc").limit(30)
    @activities_count = Activity.all.length
  end

end
