require 'slack_response'

helpers = Module.new do
  def send_slash_command(command, **keywords)
    fail "Command missing leading /" unless command.start_with?("/")
    keywords[:command], keywords[:text] = command.split(" ", 2)
    post('/slack/actions', slash_command_payload(keywords))
  end

  def last_channel_response
    expect(last_response.status).to eq 200

    if last_response.headers['Content-Type'] == 'application/json'
      attrs = JSON.parse(last_response.body, symbolize_names: true)
    else
      attrs = { text: last_response.body }
    end

    SlackResponse.new(attrs)
  end

  def receive_button_press(name:, value:, text:, callback_id:, **options)
    options[:attachments] ||= []
    options[:callback_id] ||= callback_id

    if options[:attachments].empty?
      options[:attachments] << {
        callback_id: callback_id,
        fallback: "An action",
        actions: [
          text: text,
          name: name,
          value: value,
          type: "button"
        ]
      }
    end

    options[:actions] = [
      { name: name, type: "button", value: value, text: text }
    ]

    payload = interactive_message_payload(options)

    post('/slack/actions', payload)
  end
end

RSpec.configure { |config| config.include(helpers) }
