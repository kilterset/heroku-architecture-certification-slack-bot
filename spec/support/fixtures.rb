require 'faker'
require 'securerandom'

fixtures = Module.new do
  def slash_command_payload(**attributes)
    {
      team_id: "T#{rand(10_000)}",
      team_domain: Faker::Internet.domain_word,
      channel_id: "C#{rand(10_000)}",
      channel_name: Faker::Internet.domain_word,
      user_id: "U#{rand(10_000)}",
      user_name: Faker::Internet.username,
      command: "/#{Faker::Internet.domain_word}",
      text: Faker::Company.bs,
      response_url: Faker::Internet.url,
      trigger_id: SecureRandom.hex,
    }.merge(attributes)
  end

  def interactive_message_payload(original_message: {}, **attributes)
    original_message = slash_command_payload(original_message)

    {
      type: "interactive_message",
      actions: [
        {
          name: Faker::Internet.domain_word,
          selected_options: [
            {
              value: "C#{rand(10_000)}"
            }
          ]
        }
      ],
      callback_id: "callback-#{Faker::Internet.domain_word}",
      team: {
        id: "T#{rand(10_000)}",
        domain: Faker::Internet.domain_word
      },
      channel: {
        id: "C#{rand(10_000)}",
        name: Faker::Internet.domain_word
      },
      user: {
        id: "U#{rand(10_000)}",
        name: Faker::Internet.username
      },
      action_ts: Time.now.to_f.to_s,
      message_ts: Time.now.to_f.to_s,
      attachment_id: '1'
    }.merge(attributes)
  end
end

RSpec.configure { |config| config.include(fixtures) }
