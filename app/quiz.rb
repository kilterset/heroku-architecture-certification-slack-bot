require 'yaml'

class Quiz
  PATHS = Pathname(__dir__).parent.join('data', 'quizzes').children

  Question = Struct.new(:text, :choices, keyword_init: true) do
    def initialize(*args)
      super
      fail "No correct choice given for question #{text.inspect}" unless correct_choice
    end

    def correct_choice
      choices.find { |choice| choice.correct? }
    end
  end

  class Choice
    CORRECTNESS_SUFFIX = '*'.freeze

    attr_reader :text

    def initialize(value)
      @text = value.chomp(CORRECTNESS_SUFFIX).strip
      @is_correct = value.end_with?(CORRECTNESS_SUFFIX)
    end

    def correct?
      @is_correct
    end
  end

  attr_reader :name, :questions

  def initialize(name:, questions:)
    @name = name
    @questions = questions
    puts "[Quiz] #{name}: #{questions.count} questions"
  end

  def find_question(text)
    questions.find { |question| question.text == text }
  end

  def self.all
    PATHS.map { |path| from_yaml(path) }
  end

  def self.from_yaml(io)
    data = YAML.safe_load(io.read).transform_keys(&:to_sym)
    from_data(data)
  end

  def self.from_data(questions:, **options)
    questions = questions.map do |text, choices|
      Question.new(
        text: text,
        choices: choices.map { |value| Choice.new(value) }
      )
    end

    new(questions: questions, **options)
  end
end
