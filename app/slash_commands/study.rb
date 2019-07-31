require 'quiz'

module SlashCommands
  class Study
    ALPHABET = ('A'..'Z').to_a.freeze
    DEFAULT_QUIZ = Quiz.all.first

    attr_reader :request

    def initialize(request)
      @request = request
    end

    def quiz
      DEFAULT_QUIZ
    end

    def question
      @question ||= request.interactive? ? inferred_question : random_question
    end

    def actions
      question.choices.map.with_index do |choice, i|
        {
          name: question.text,
          text: ALPHABET[i],
          value: choice.text,
          type: 'button'
        }
      end
    end

    def response
      request.interactive? ? answer : ask
    end

    def ask
      request.response(
        text: question.text, attachments: [question_attachment]
      )
    end

    def random_question
      quiz.questions.sample
    end

    def answer
      if correct?
        @question = random_question

        request.response(
          text: "✅ Correct!\n#{question.text}",
          replace_original: false,
          attachments: [question_attachment]
        )
      else
        request.response(text: '😔 Try again', replace_original: false)
      end
    end

    def correct?
      request.actions.first['value'] == question.correct_choice.text
    end

    def inferred_question
      question_text = request.actions.first['name']
      quiz.find_question(question_text)
    end

    def question_body
      question.choices.map.with_index { |choice, i| "#{ALPHABET[i]}. #{choice.text}" }.join("\n")
    end

    def question_attachment
      {
        text: question_body,
        callback_id: '/study',
        attachment_type: 'default',
        actions: actions
      }
    end
  end
end
