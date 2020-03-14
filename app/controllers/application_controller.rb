class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
 
  private

  # Checks if user is logged in to permit action
  def only_logged_in
    unless logged_in?
      store_location
      flash[:danger] = 'Please log in to perform that action'
      redirect_to login_url
    end
  end

end
