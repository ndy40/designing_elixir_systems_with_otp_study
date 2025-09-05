defmodule QuizBuilders do
  alias Mastery.Core.{Quiz, Template, Response, Question}

  defmacro __using__(_options) do
    quote do
      alias Mastery.Core.{Quiz, Template, Response}
      import QuizBuilders, only: :functions
    end
  end


def template_fields(overrides \\ [ ]) do
  Keyword.merge(
    [
      name: :single_digital_addition,
      category: :addition,
      instructions: "Add the numbers",
      raw: "<%= @left %> + <%= @right %>",
      generators: addition_generators(single_digits()),
      checker: &addition_checker/2
    ],
    overrides
  )
end

def double_digital_addition_template_fields() do
  template_fields(
    name: :double_digital_addition,
    generators: addition_generators(double_digits())
  )
end

def addition_generators(left, right \\ nil) do
  %{left: left, right: right || left}
end

def double_digits(), do: Enum.to_list(10..99)

def single_digits(), do: Enum.to_list(1..9)

def addition_checker(substitutions, answer) do
  left = Keyword.fetch!(substitutions, :left)
  right = Keyword.fetch!(substitutions, :right)
  to_string(left + right) == String.trim(answer)
end

def quiz_fields(overrides) do
 Keyword.merge([title: "Simple Arithmetic"], overrides)
end

def build_quiz(quiz_overrides \\ []) do
  quiz_overrides
  |> quiz_fields
  |> Quiz.new
end

def build_question(overrides \\ [ ] ) do
  overrides
  |> template_fields
  |> Template.new
  |> Question.new
end

def build_quiz_with_two_templates(quiz_overrides \\ []) do
  build_quiz(quiz_overrides)
  |> Quiz.add_template(template_fields())
  |> Quiz.add_template(template_fields(double_digital_addition_template_fields()))

end

end
