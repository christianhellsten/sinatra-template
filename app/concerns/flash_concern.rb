#
# Flash for Sinatra.
#
module FlashConcern
  extend ActiveSupport::Concern

  included do
    use Rack::Flash, :accessorize => [:info, :error, :success], :sweep => true
  end

  [:error, :info, :success].each do |key|
    class_eval "
    def flash_#{key}(key, now=true)
      message(key, :#{key}, now)
    end
    "
  end

  def message(key, type=:notice, now=true)
    hash = now ? flash.now : flash
    #hash.send("#{type}=", I18n.t(key))
    hash[type] = key
  end
end
