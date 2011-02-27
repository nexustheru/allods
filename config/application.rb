require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'pp'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module Allods
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.i18n.default_locale = :fr
    config.filter_parameters += [:password, :password_confirmation]

    config.generators do |g|
      g.template_engine :haml
      g.test_framework :rspec
    end

    config.action_view.javascript_expansions[:defaults]       = %w(rails)
    config.action_view.javascript_expansions[:jquery_plugins] = %w(jquery.livequery.js jquery.dataTables.js jquery.jeditable.js)
    # use minified versions in production
    minified = Rails.env.production? ? '.min' : ''
    [:jquery_plugins].each do |js_exp|
      config.action_view.javascript_expansions[js_exp] = config.action_view.javascript_expansions[js_exp].map { |js| js.gsub(/.js$/, minified + '.js') }
    end
    
    config.after_initialize do
      unless Rails.env.production?
        require "#{Rails.root}/spec/spec_helper"
      end

      SimpleForm.wrapper_tag = :p
      
      $stderr.puts 'Using default locale ' + I18n.locale.inspect
    end
  end
end