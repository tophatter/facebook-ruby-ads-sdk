# frozen_string_literal: true

# To publish the next version:
# gem build facebook_ads.gemspec
# gem push facebook_ads-0.7.0.gem
Gem::Specification.new do |s|
  s.name        = 'facebook_ads'
  s.version     = '0.7.0'
  s.platform    = Gem::Platform::RUBY
  s.licenses    = ['MIT']
  s.authors     = ['Chris Estreich']
  s.email       = 'chris@tophatter.com'
  s.homepage    = 'https://github.com/tophatter/facebook-ruby-ads-sdk'
  s.summary     = 'Facebook Marketing API SDK for Ruby.'
  s.description = "This gem allows to easily manage your Facebook ads via Facebook's Marketing API in ruby."

  s.extra_rdoc_files = ['README.md']

  s.required_ruby_version = '>= 2.5'

  s.add_dependency 'hashie'
  s.add_dependency 'rest-client', '>= 1.6'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']
end
