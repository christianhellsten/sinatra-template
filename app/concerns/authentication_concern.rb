#
# Authentication for Sinatra.
#
module AuthenticationConcern
  extend ActiveSupport::Concern

  included do
    class_attribute :require_user

    get '/signout' do
      flash_success "action.sessions.signed_out", false
      session[:user_id] = nil
      redirect '/'
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  rescue ActiveRecord::RecordNotFound
    user_signed_out
    nil
  end

  def user_signed_in(user)
    session[:user_id] = user.id
    after_sign_in(user)
  end

  #
  # Customizable callback for customization of sign in
  #
  def after_sign_in(user)
    redirect_to = session.delete(:redirect_to)
    # NOTE: Store email in cookie so we can show it and still cache page
    response.set_cookie(:email, value: user.email, path: '/')
    redirect_to.present? ? redirect_to : '/'
  end

  def user_signed_out
    session.clear
    response.delete_cookie :email
  end

  def require_user!
    unless current_user
      session[:redirect_to] = request.path
      redirect '/login'
    end
  end

  def signed_in?
    !!current_user
  end
end
