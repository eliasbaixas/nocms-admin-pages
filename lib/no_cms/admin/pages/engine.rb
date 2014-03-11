require 'nocms_pages'
require 'nocms_admin'
require 'jquery-rails'

module NoCms
  module Admin
    module Pages
      class Engine < ::Rails::Engine
        isolate_namespace NoCms::Admin::Pages
      end
    end
  end
end
