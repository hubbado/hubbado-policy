# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = "hubbado-policy"
  s.version = "0.0.0"
  s.summary = " "
  s.description = " "

  s.authors = ["devs@hubbado.com"]
  s.homepage = 'https://github.com/hubbado/hubbado-policy'

  s.metadata["allowed_push_host"] = "https://rubygems.pkg.github.com/hubbado"
  s.metadata["github_repo"] = s.homepage
  s.metadata["homepage_uri"] = s.homepage

  s.require_paths = ["lib"]
  s.files = Dir.glob("{lib}/**/*")
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = ">= 3.3"

  s.add_dependency "i18n"
  s.add_dependency "evt-casing"
  s.add_dependency "evt-record_invocation"
  s.add_dependency "evt-template_method"

  s.add_development_dependency "debug"
  s.add_development_dependency "hubbado-style"
  s.add_development_dependency "test_bench"
end
