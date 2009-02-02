# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'bb4c7b3df81be0ad606d5f4af93a2459'
  
  before_filter :login_required
  
  def login_required
    store_location
      (!session[:user_id].nil? and !User.find(session[:user_id]).nil?) ? (return true) : (redirect_to :controller=> :sessions and return false)
  end

  def store_location
    session[:return_to] = request.request_uri
  end

end
