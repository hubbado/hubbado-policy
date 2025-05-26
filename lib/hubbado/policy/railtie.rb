module Hubbado
  module Policy
    class Railtie < ::Rails::Railtie
      initializer "hubbado-policy.initialized" do |app|
        ::I18n.load_path << ::File.expand_path("../../../../config/locales/en.yml", __FILE__)
      end
    end
  end
end
