source 'https://rubygems.org'

ruby File.read('.ruby-version')

# Server interface
gem 'rack'

# Verify signed Slack requests
gem 'rack-slack_request_verification', '~> 1.0.0.pre2'

group 'test' do
  # Test framework
  gem 'rspec'

  # Test functionality for Rack
  gem 'rack-test'

  # Realistic test data
  gem 'faker'
end
