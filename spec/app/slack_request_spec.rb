require 'slack_request'

RSpec.describe 'SlackRequest' do
  it 'parses slash command request information' do
    payload = slash_command_payload(
      channel_id: 'C1000',
      command: '/command',
      text: 'with options'
    )

    env = Rack::MockRequest.env_for("/slack/actions", params: payload)
    request = SlackRequest.new(env)

    expect(request).not_to be_interactive
    expect(request.channel_id).to eq 'C1000'
    expect(request.command).to eq '/command'
    expect(request.command_name).to eq 'command'
    expect(request.text).to eq 'with options'
  end

  it 'parses interactive message request information' do
    payload = interactive_message_payload(
      channel_id: 'C1000',
      text: 'with options'
    )

    env = Rack::MockRequest.env_for("/slack/actions", params: payload)
    request = SlackRequest.new(env)

    expect(request).to be_interactive
  end

  it 'can create a response' do
    payload = slash_command_payload
    env = Rack::MockRequest.env_for("/slack/actions", params: payload)
    request = SlackRequest.new(env)
    response = request.response(text: 'responded')
    expect(response).to be_a SlackResponse
    expect(response.text).to eq 'responded'
  end
end
