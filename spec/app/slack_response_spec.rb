RSpec.describe 'SlackResponse' do
  it 'has arbitrary attributes' do
    response = SlackResponse.new(text: 'hello', crayon: 'purple')
    expect(response.attributes).to eq(text: 'hello', crayon: 'purple')
  end

  it 'is ephemeral by default' do
    response = SlackResponse.new
    expect(response).not_to be_in_channel
    expect(response).to be_ephemeral
  end

  it 'can be in-channel' do
    response = SlackResponse.new(response_type: 'in_channel')
    expect(response).to be_in_channel
    expect(response).not_to be_ephemeral
  end
end
