require 'i18n'
require 'template_method'; TemplateMethod.activate
require 'casing'

# TODO: is this the right way to do it?
# Should we load only in tests, for the whole lib or delegate the I18n config to the project
# including this lib?
I18n.load_path += Dir[File.expand_path("config/locales") + "/*.yml"]
I18n.default_locale = :en

require 'hubbado_policy/result'
require 'hubbado_policy/policy'
