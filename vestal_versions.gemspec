# encoding: utf-8

Gem::Specification.new do |gem|
  gem.name    = 'vestal_versions'
  gem.version = '3.0.0'

  gem.authors     = ['Steve Richert', "James O'Kelly", 'C. Jason Harrelson', 'Neil Gupta']
  gem.email       = ['steve.richert@gmail.com', 'dreamr.okelly@gmail.com', 'jason@lookforwardenterprises.com', 'neil@metamorphium.com']
  gem.description = "Keep a DRY history of your ActiveRecord models' changes"
  gem.summary     = gem.description
  gem.homepage    = 'http://github.com/neilgupta/vestal_versions'
  gem.license     = 'MIT'

  gem.add_dependency 'activerecord', '>= 4', '< 6'
  gem.add_dependency 'activesupport', '>= 4', '< 6'

  gem.add_development_dependency 'bundler', '~> 1.17'
  gem.add_development_dependency 'rake', '~> 12.3'

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(/^spec/)
  gem.require_paths = ['lib']
end
