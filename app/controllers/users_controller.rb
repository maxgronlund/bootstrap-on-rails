class UsersController < InheritedResources::Base
  has_scope :page, :default => 1
  load_and_authorize_resource

  helper_method :sort_column, :sort_direction

  def index
    @menu='admin'
    #return_path = users_path # or request.referer
    session[:go_to_after_edit] = users_path
    #@users = User.search(params[:search]).order(sort_column + " " + sort_direction).page(params[:page]).per(2)
    if mobile_device?
      @users = User.search(params[:search]).order(sort_column + " " + sort_direction).page(params[:page]).per(10)
    else
      @users = User.search(params[:search]).order(sort_column + " " + sort_direction).page(params[:page]).per(25)
    end
  end

  def show
    @breadcrumbs = { "home" => root_path, "users" => users_path, @user.name => user_path(@user) }

    session[:go_to_after_edit] = user_path(@user)
    #return_path = user_path(@user)  # !!! perhaps a system vide helper ?
    show!
  end

#  def create
#    user = User.find_by_email(params[:email])
#    if user && user.authenticate(params[:password])
#      session[:user_id] = user.id
#      redirect_to root_url, :notice => "Logged in!"
#    else
#      flash.now.alert = "Invalid email or password"
#      render "new"
#    end
#  end


  
  def create
    create! do |success, failure|
      success.html do
        
        unless current_user
          # log users created by themself in 
           user = User.authenticate(@user.email, @user.password)
           cookies[:auth_token] = user.auth_token
           session[:user_id] = user.id
        end

        if params[:user][:image]
          redirect_to crop_user_path(@user), :notice => "Signed up!"
        else
          if mobile_device?
            redirect_to users_url
          else
            redirect_to user_path(@user), :notice => "Signed up!"
          end
        end
      end
      #flash.error = "You are fuckd!"
      failure.html { render 'new' }
    end
  end
  
  def update
    remove_password_fields_if_blank! params[:user]
    
    if params[:user][:image] && params[:user][:remove_image] != '1'
      update! { crop_user_path }
    else
      update! { return_path(user_path) }
    end
  end

  
  def crop
    @crop_version = (params[:version] || :large).to_sym
    @user.get_crop_version! @crop_version
    @version_geometry_width, @version_geometry_height = AvatarUploader.version_dimensions[@crop_version]
    
  end

  def crop_update
    @user.crop_x = params[:user]["crop_x"]
    @user.crop_y = params[:user]["crop_y"]
    @user.crop_h = params[:user]["crop_h"]
    @user.crop_w = params[:user]["crop_w"]
    @user.crop_version = params[:user]["crop_version"]
    @user.save
    
    goto = session.delete(:go_to_after_edit) || root_path
    redirect_to goto
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_url 
  end
  
  
private

  def remove_password_fields_if_blank!(user_params)
    if user_params[:password].blank? and user_params[:password_confirmation].blank?
      user_params.delete :password
      user_params.delete :password_confirmation
    end
  end

  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
  end
end
