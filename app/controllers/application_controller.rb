class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!


  private

  def track_activity(jem, trackable, user, action = params[:action])
    jem.activities.create! action: params[:action], trackable: trackable, trackable_name: trackable.class == Script ? File.basename(trackable.file.url) : trackable.name, user_id: user.id
  end



  protected

  def after_sign_in_path_for(resource)
    return jems_path
  end

  
end
