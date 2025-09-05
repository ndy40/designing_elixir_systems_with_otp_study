defmodule Mastery.Core.Response do
  defstruct ~w[quize_title template_name to email answer correct timestamp]a

  def new(quiz, email, answer) do
    question = quiz.current_question
    template = question.template

    %__MODULE__{
      quize_title: quiz.title,
      template_name: template.name,
      email: email,
      to: question,
      answer: answer,
      correct: template.checker.(question.substitutions, answer),
      timestamp: DateTime.utc_now()
    }
  end
end
