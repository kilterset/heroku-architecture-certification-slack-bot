require 'quiz'

RSpec.describe 'Quiz' do
  def quiz_fixture
    Quiz::PATHS.find { |path| path.basename.to_s == 'heroku-architecture.yml' }
  end

  it 'can load a quiz from YAML' do
    quiz = Quiz.from_yaml(quiz_fixture)
    question = quiz.questions.first
    choices = question.choices

    expect(question.text).to eq('Salesforce Connect custom adapters support:')
    expect(choices.first.text).to eq('Cross-object relationships')
    expect(choices.first).not_to be_correct
    expect(choices.last.text).to eq('All of the above')
    expect(choices.last).to be_correct
  end
end
