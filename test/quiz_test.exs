defmodule QuizTest do
  use ExUnit.Case
  use QuizBuilders

  defp eventually_pick_other_template(quiz, template) do
    Stream.repeatedly(fn -> Quiz.select_question(quiz).current_question.template end)
    |> Enum.find(fn other -> other != template end)
  end

  defp template(quiz), do: quiz.current_question.template

  defp right_answer(quiz)
end
