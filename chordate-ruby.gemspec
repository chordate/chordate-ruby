require File.expand_path('../lib/chordate-ruby/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors     = %w(bnorton)
  gem.email       = 'brian.nort@gmail.com'
  gem.summary     = ''
  gem.description = ''
  gem.homepage    = 'http://github.com/chordate/chordate-ruby'
  gem.license     = 'MIT'
  gem.require_paths = %w(lib)

  gem.version     = Chordate::Version::STRING
  gem.name        = 'chordate-ruby'

  gem.files       = `git ls-files`.split("\n")
  gem.test_files  = `git ls-files -- spec/*`.split("\n")

  gem.add_dependency             'typhoeus', '> 0.5.0'
  gem.add_dependency             'celluloid'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'webmock'
end
