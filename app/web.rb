require 'slack_request'
require 'slack_response'
require 'slash_commands'

$stdout.sync = true

module Web
  DEFAULT_HEADERS = { 'Content-Type' => 'application/json' }.freeze

  module_function

  def call(env)
    request = SlackRequest.new(env)
    response = SlashCommands.response_for(request)
    body = response.to_json

    [200, DEFAULT_HEADERS, [body]]
  end
end
