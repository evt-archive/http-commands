Gem::Specification.new do |s|
  s.name = 'http-commands'
  s.version = '0.1.2.0'
  s.summary = 'Convenience abstractions for common HTTP operations, such as post and get'
  s.description = ' '

  s.authors = ['The Eventide Project']
  s.email = 'opensource@eventide-project.org'
  s.homepage = 'https://github.com/eventide-project/http-commands'
  s.licenses = ['MIT']

  s.require_paths = ['lib']
  s.files = Dir.glob('{lib}/**/*')
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.3.3'

  s.add_runtime_dependency 'clock'
  s.add_runtime_dependency 'connection-client'
  s.add_runtime_dependency 'http-protocol'

  s.add_development_dependency 'test_bench'
end
