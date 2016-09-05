Gem::Specification.new do |s|
  s.name        = 'facebook_ads'
  s.version     = '0.1.0'
  s.platform    = Gem::Platform::RUBY
  s.licenses    = ['MIT']
  s.authors     = ['Chris Estreich']
  s.email       = 'cestreich@gmail.com'
  s.homepage    = 'https://github.com/cte/marketing-api-ruby'
  s.summary     = "Ruby interface to Facebook's Marketing API."
  s.description = "This gem allows to easily access Facebook's Marketing API in ruby. See https://developers.facebook.com/docs/reference/ads-api/"

  s.extra_rdoc_files = ['README.markdown']

  s.files         = `git ls-files`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.required_ruby_version = '~> 2.0'

  s.add_dependency 'activesupport', '~> 4.2'
  s.add_dependency 'httmultiparty', '~> 0.3'
  s.add_dependency 'hashie', '~> 3.4'

  s.add_development_dependency 'bundler', '~> 1.7'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'pry', '~> 0.10'
  s.add_development_dependency 'awesome_print', '~> 1.7'
end
