#
# Asset pipeline for Sinatra based on Sprockets.
#
# NOTE: In production use rake assets:compile to compile assets and generate an
# asset version file.
#
module AssetsConcern
  extend ActiveSupport::Concern

  included do
    set :assets_prefix, '/assets'
    set :assets_path, File.join(App.root, 'public', assets_prefix)
    set :assets_precompile, true
  end

  module ClassMethods
    #
    # Returns the current version.
    #
    def asset_version
      @@asset_version ||= read_asset_version
    end

    def read_asset_version
      file = 'public/assets/version'
      if File.exist?(file)
        File.read(file).to_i
      else
        nil
      end
    end

    #
    # Returns the path to the assets.
    #
    def asset_path(name, type)
      if App.asset_version
        file = "/assets/#{name}-#{App.asset_version}.#{type}"
      else
        file = "/assets/#{name}.#{type}"
      end
    end

    def sprockets
      require "yui/compressor"
      project_root = File.expand_path(File.dirname(__FILE__))
      assets = Sprockets::Environment.new(project_root)
      # Include bootstrap
      %w{javascripts stylesheets images}.each do |type|
        assets.append_path Compass::Frameworks['bootstrap'].templates_directory + "/../vendor/assets/#{type}"
      end
      # Include bower managed components
      %w(bower_components app/js app/css).each do |path|
        assets.append_path(File.join(App.root, path))
      end
      assets
    end
  end
end

