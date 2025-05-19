ENV["CONSOLE_DEVICE"] ||= "stdout"
ENV["LOG_LEVEL"] ||= "_min"

puts RUBY_DESCRIPTION

puts
puts "TEST_BENCH_DETAIL: #{ENV["TEST_BENCH_DETAIL"].inspect}"
puts

require_relative "../init.rb"
require "hubbado-policy/controls"

require "test_bench"; TestBench.activate
require "debug"

# TODO: is this the right way to do it?
# Should we load only in tests, for the whole lib or delegate the I18n config to the project
# including this lib?
I18n.load_path += Dir[File.expand_path("config/locales") + "/*.yml"]
I18n.default_locale = :en

include HubbadoPolicy
