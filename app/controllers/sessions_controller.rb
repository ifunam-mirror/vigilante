class SessionsController < ApplicationController
  skip_before_filter :login_required

  def index
    respond_to do |format|
      format.html { render :action => 'index' }
    end
  end
  alias_method :show, :index
  
  def login
    respond_to do |format|
      if User.authenticate?(params[:user][:login],params[:user][:passwd])
        session[:user_id] = User.find_by_login(params[:user][:login]).id
        flash[:notice] = "Bienvenido(a), ha iniciado una sesión en vigilante!"
        format.html { redirect_to(cameras_url) }
      else
        flash[:notice] = "El login o el password es incorrecto!"
        format.html { render :action => "index" }
      end
    end
  end

  def destroy
    reset_session
    respond_to do |format|
      format.html {  render :action => "logout" }
    end
  end
end
