defmodule Mastery.Boundary.QuizManager do
  alias Mastery.Core.Quiz
  use GenServer

  def init(quizzes) when is_map(quizzes) do
    {:ok, quizzes}
  end

  def init(_quizzes), do: {:error, "quizzes must be map"}

  def start_link(opts \\ [ ]) do
    GenServer.start_link(__MODULE__, %{ }, opts)
  end

  def handle_call({:build_quiz, quize_fileds}, _from, quizzes) do
    quiz = Quiz.new(quize_fileds)
    new_quizzes = Map.put(quizzes, quiz.title, quiz)
    {:reply, :ok, new_quizzes}
  end

  def handle_call({:add_template, quiz_title, template_fields}, _from, quizzes) do
    new_quizes = Map.update!(quizzes, quiz_title, fn quiz-> Quiz.add_template(quiz, template_fields) end)
    {:reply, :ok, new_quizes}
  end

  def handle_call({:lookup_quiz_by_title, quiz_title}, _from, quizzes) do
    quiz = Map.get(quizzes, quiz_title)
    {:reply, quiz, quizzes}
  end

  def build_quiz(manager \\ __MODULE__, quiz_fields) do
    GenServer.call(manager, {:build_quiz, quiz_fields})
  end

  def add_template(manager \\ __MODULE__, quiz_title, template_fields) do
    GenServer.call(manager, {:add_template, quiz_title, template_fields})
  end

  def look_up_quiz_by_title(manager \\ __MODULE__, quiz_title) do
    GenServer.call(manager, {:lookup_quiz_by_title, quiz_title})
  end
end
