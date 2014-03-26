# encoding: utf-8

require_relative 'config/boot'

class App < Sinatra::Base
  set :environments, %w{development test production staging}
  # NOTE: use direnv to set the session secret in the .envrc file
  set :session_secret, ENV['SESSION_SECRET']
  enable :sessions

  register Sinatra::Partial
  register Sinatra::CompassSupport

  use ActiveRecord::ConnectionAdapters::ConnectionManagement
  # Allow Rails-type HTTP methods in forms
  use Rack::MethodOverride
  # NOTE protect staging environment with basic authentication
  use Rack::Auth::Basic do |username, password|
    username == 'admin' and password == 'admin'
  end if ENV['RACK_ENV'] == 'staging'

  # HTML forms now require: input name="authenticity_token" value=session[:csrf] type="hidden"
  use Rack::Protection::AuthenticityToken 

  set :root, App.root
  set :server, :puma
  set :public_folder, File.dirname(__FILE__) + '/public'
  set :views, File.dirname(__FILE__) + '/app/views'
  # Use slim
  set :slim, layout_engine: :slim, use_html_safe: true, pretty: (App.environment != :production)
  set :partial_template_engine, :slim

  include AssetsConcern
  include FlashConcern
  include AuthenticationConcern

  helpers Sinatra::ContentFor
  helpers WillPaginate::Sinatra::Helpers
  helpers AppHelpers

  error do
    r :'errors/500'
  end

  error 403 do
    r 'errors/403'
  end

  not_found do
    r :'errors/404'
  end

  error ActiveRecord::RecordNotFound do
    r :'errors/404'
  end

  before do
    I18n.locale = params[:lang] || I18n.default_locale
    I18n.reload! if App.environment == :development
    init_csrf_token
    redirect '/' if self.class.require_user && !signed_in?
  end

  protected

  def init_csrf_token
    env['rack.session'][:csrf] ||= SecureRandom.base64(32)
  end

  def r(template, options = {})
    file = options.fetch(:layout) { :'layouts/default' }.to_sym
    slim template.to_sym, layout: file
  end

  def bust_cache
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
end

require_relative 'config/init'
