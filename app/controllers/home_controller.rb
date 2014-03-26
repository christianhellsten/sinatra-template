# encoding: utf-8
class HomeController < App
  get '/' do
    r 'index', layout: 'layouts/fullscreen'
  end
end
