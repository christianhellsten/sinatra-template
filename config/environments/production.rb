App.disable :show_exceptions
App.sprockets.js_compressor  = YUI::JavaScriptCompressor.new
App.sprockets.css_compressor = YUI::CssCompressor.new
App.log.level = Logger::INFO
App.use Rack::Cache,
  :verbose => false,
  :allow_reload => false,
  :allow_revalidate => false,
  :metastore   => "file:#{File.join(App.root, 'tmp', 'cache', 'meta')}",
  :entitystore => "file:#{File.join(App.root, 'tmp', 'cache', 'body')}"
