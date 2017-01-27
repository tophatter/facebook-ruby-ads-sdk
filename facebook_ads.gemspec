# To release a new version:
# gem build facebook_ads.gemspec
# gem push facebook_ads-0.1.9.gem
Gem::Specification.new do |s|
  s.name        = 'facebook_ads'
  s.version     = '0.1.11'
  s.platform    = Gem::Platform::RUBY
  s.licenses    = ['MIT']
  s.authors     = ['Chris Estreich']
  s.email       = 'cestreich@gmail.com'
  s.homepage    = 'https://github.com/cte/facebook-ruby-ads-sdk'
  s.summary     = 'Facebook Marketing API SDK for Ruby.'
  s.description = "This gem allows to easily manage your Facebook ads via \
                   Facebook's Marketing API in ruby."
  s.extra_rdoc_files = ['README.md']
  s.files         = `git ls-files`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map do |f|
    File.basename(f)
  end
  s.require_paths = ['lib']
  s.required_ruby_version = '~> 2.0'
  s.add_dependency 'rest-client', '>= 1.6'
  s.add_dependency 'hashie', '~> 3.4'
end
