require 'json'

class SlackResponse
  attr_reader :attributes

  def initialize(**keywords)
    @attributes = keywords
  end

  def text
    attributes[:text]
  end

  def in_channel?
    attributes[:response_type] == 'in_channel'
  end

  def attachments
    attributes[:attachments]
  end

  def ephemeral?
    !in_channel?
  end

  def to_json
    JSON.generate(attributes)
  end
end
