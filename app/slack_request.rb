require 'rack/request'
require 'ostruct'

class SlackRequest < SimpleDelegator
  INTERACTIVE_MESSAGE_TYPE = 'interactive_message'.freeze

  def initialize(env)
    params = Rack::Request.new(env).params
    params = JSON.parse(params['payload'], symbolize_keys: true) if params['payload']
    super OpenStruct.new(params)
  end

  def response(**kwargs)
    SlackResponse.new(kwargs)
  end

  def command_name
    value = respond_to?(:command) ? command : callback_id
    value.delete_prefix("/")
  end

  def interactive?
    type == INTERACTIVE_MESSAGE_TYPE if respond_to?(:type)
  end
end
