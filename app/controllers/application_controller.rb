class ApplicationController < ActionController::Base
  protect_from_forgery 
  
#  before_filter :get_site_info
  helper_method :current_user
  
  private
#  def current_user
#    @current_user ||= User.find(session[:user_id]) if session[:user_id]
#  end
  def current_user
      @current_user ||= User.find_by_auth_token( cookies[:auth_token]) if cookies[:auth_token]
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to no_access_index_path, :alert => exception.message
  end
  
#  def after_sign_in_path_for(resource)
#    if current_user.admin_or_super?
#      admin_index_path
#    else
#      user_path(resource)
#    end
#  end


protected

  def return_path=(path)
    session[:go_to_after_edit] = path
  end

  def return_path(default_path)
    (session[:go_to_after_edit] || default_path).tap do |path|
      session[:go_to_after_edit] = nil
    end
  end

end
