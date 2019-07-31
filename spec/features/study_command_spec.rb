RSpec.describe '/study' do
  ALPHABET = ('A'..'Z').to_a

  let(:quiz) { SlashCommands::Study::DEFAULT_QUIZ }
  let(:question) { quiz.dup.questions.first }

  before do
    allow(quiz).to receive(:questions) { [question] }
  end

  it 'responds with something to study' do
    send_slash_command("/study")

    expect(last_channel_response).to be_ephemeral

    attachment = last_channel_response.attachments.last
    actions = attachment.fetch(:actions)
    action_types = actions.map { |action| action[:type] }
    action_names = actions.map { |action| action[:name] }
    action_texts = actions.map { |action| action[:text] }
    choice_values = question.choices.map(&:text)

    expect(last_channel_response.text).to eq(question.text)
    expect(attachment[:callback_id]).to eq '/study'

    expect(actions.length).to be 4
    expect(action_types).to be_all { |type| type == 'button' }
    expect(action_texts).to eq ['A', 'B', 'C', 'D']
    expect(action_names).to be_all(question.text)
  end

  describe 'actions' do
    before { send_slash_command('/study') }

    it 'responds when the response is wrong' do
      original_message = last_channel_response

      wrong_answer_index = question.choices.index { |choice| !choice.correct? }
      wrong_answer = question.choices[wrong_answer_index].text
      wrong_answer_letter = ALPHABET[wrong_answer_index]

      receive_button_press(
        name: question.text,
        text: wrong_answer_letter,
        value: wrong_answer,
        callback_id: '/study',
        original_message: original_message.attributes
      )

      expect(last_channel_response).to be_ephemeral
      expect(last_channel_response.text).to include('Try again')
    end

    it 'responds with a fresh question' do
      original_message = last_channel_response

      right_answer_index = question.choices.index { |choice| choice.correct? }
      right_answer = question.choices[right_answer_index].text
      right_answer_letter = ALPHABET[right_answer_index]

      receive_button_press(
        name: question.text,
        text: right_answer_letter,
        value: right_answer,
        callback_id: '/study',
        original_message: original_message.attributes
      )

      expect(last_channel_response).to be_ephemeral
      expect(last_channel_response.text).to include('Correct')
    end
  end
end
