lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'breaker_box/version'

prerelease = ENV['SC_PRERELEASE'] == 'true'

Gem::Specification.new do |s|
  s.name = 'breaker_box'
  s.description = 'A Circuit Breaker system'
  s.version = if prerelease
                "#{BreakerBox::VERSION}.pre#{Time.now.to_i}"
              else
                BreakerBox::VERSION
              end
  s.authors = ['Sitter City']
  s.email = ['dev@sittercity.com']

  s.homepage = 'https://github.com/sittercity/breaker_box'
  s.summary = 'Sittercity\'s Circuit Breaker Gem'
  s.files = Dir['lib/**/*.rb']
  s.require_paths = ['lib', 'spec']
  s.add_runtime_dependency('redis', '< 4')
  s.add_development_dependency('json', '< 3')
end
