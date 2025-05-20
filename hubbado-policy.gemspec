Gem::Specification.new do |s|
  s.name = "hubbado-policy"
  s.version = "1.0.0"
  s.summary = "A lightweight, flexible policy framework for Ruby applications"

  s.authors = ["Hubbado Devs"]
  s.email = ["devs@hubbado.com"]
  s.homepage = 'https://github.com/hubbado/hubbado-policy'
  s.license  = "MIT"

  s.metadata["homepage_uri"] = s.homepage
  s.metadata["source_code_uri"] = s.homepage
  s.metadata["changelog_uri"] = "#{s.homepage}/blob/master/CHANGELOG.md"

  s.require_paths = ["lib"]
  s.files = Dir.glob(%w[
    lib/**/*.rb
    config/**/*.yml
    *.gemspec
    LICENSE*
    README*
    CHANGELOG*
  ])
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = ">= 3.2"

  s.add_runtime_dependency "i18n"
  s.add_runtime_dependency "evt-casing"
  s.add_runtime_dependency "evt-record_invocation"
  s.add_runtime_dependency "evt-template_method"

  s.add_development_dependency "debug"
  s.add_development_dependency "hubbado-style"
  s.add_development_dependency "test_bench"
end
