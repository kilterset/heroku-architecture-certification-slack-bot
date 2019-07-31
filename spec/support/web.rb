require 'web'
require 'rack/test'

helpers = Module.new do
  include Rack::Test::Methods

  def app
    Web
  end
end

RSpec.configure { |config| config.include(helpers) }
