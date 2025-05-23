ENV["CONSOLE_DEVICE"] ||= "stdout"
ENV["LOG_LEVEL"] ||= "_min"

puts RUBY_DESCRIPTION

puts
puts "TEST_BENCH_DETAIL: #{ENV["TEST_BENCH_DETAIL"].inspect}"
puts

require_relative "../init.rb"
require "hubbado/policy/controls"
require "test_bench"; TestBench.activate
require "debug"

I18n.load_path += Dir[File.expand_path("test/locales") + "/*.yml"]

include Hubbado::Policy
