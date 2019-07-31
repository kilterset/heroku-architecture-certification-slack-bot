$stdout.sync = true

$LOAD_PATH.prepend File.expand_path("../app", __FILE__)
require 'web'
require 'rack/slack_request_verification'

use Rack::SlackRequestVerification, path_pattern: %r{^/slack/}
run Web
