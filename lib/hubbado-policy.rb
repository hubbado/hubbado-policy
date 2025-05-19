require 'i18n'
require 'casing'
require 'record_invocation'
require 'template_method'; TemplateMethod.activate

# TODO: is this the right way to do it?
# Should we load only in tests, for the whole lib or delegate the I18n config to the project
# including this lib?
I18n.load_path += Dir[File.expand_path("config/locales") + "/*.yml"]
I18n.default_locale = :en

require 'hubbado-policy/scope'
require 'hubbado-policy/result'
require 'hubbado-policy/policy'
