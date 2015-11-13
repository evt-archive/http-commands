ENV['CONSOLE_DEVICE'] ||= 'stdout'
ENV['LOG_COLOR'] ||= 'on'
ENV['LOG_LEVEL'] ||= 'trace'

puts RUBY_DESCRIPTION

require_relative '../init.rb'

require 'http/commands/controls'

require 'runner'

Telemetry::Logger::AdHoc.activate
