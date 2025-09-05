defmodule ResponseTest do
  use ExUnit.Case
  use QuizBuilders

  defp quiz() do
    fields = template_fields(generators: %{left: [1], right: [2]})

    build_quiz()
    |> Quiz.add_template(fields)
    |> Quiz.select_question
  end

  defp response(answer) do
    Response.new(quiz(), "mathy@example.com", answer)
  end

  defp right(context) do
    {:ok, Map.put(context, :right, response("3"))}
  end

  defp wrong(context) do
    {:ok, Map.put(context, :wrong, response("2"))}
  end

  describe "a right response and a wrong response" do
    setup [:right, :wrong]

    test "building responses check answers", %{right: right, wrong: wrong} do
      assert right.correct
      refute wrong.correct
    end


    test "a timestamp is added at build time", %{right: response} do
      assert %DateTime{ } = response.timestamp
      assert DateTime.compare(response.timestamp, DateTime.utc_now()) == :lt
    end

    test "function generators are called" do
      generators = addition_generators(fn -> 42 end, [0])
      substitutions = build_question(generators: generators).substitutions
      assert Keyword.fetch!(substitutions, :left) == generators.left.()
    end

    test "building creates asked question text" do
      question = build_question(generators: addition_generators([1], [2]))
      assert question.asked == "1 + 2"
    end
  end
end
