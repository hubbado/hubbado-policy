require "i18n"
require "casing"
require "record_invocation"
require "template_method"; TemplateMethod.activate

I18n.load_path += Dir[File.expand_path("config/locales") + "/*.yml"]
I18n.default_locale = :en

require "hubbado-policy/railtie" if defined?(Rails::Railtie)

require "hubbado-policy/scope"
require "hubbado-policy/result"
require "hubbado-policy/policy"
