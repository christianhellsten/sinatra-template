#
# Set TRUSTED_IP in .envrc
#
if defined? BetterErrors
  BetterErrors::Middleware.allow_ip! ENV['TRUSTED_IP'] if ENV['TRUSTED_IP']
end
