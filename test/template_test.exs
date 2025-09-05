defmodule TemplateTest do
  use ExUnit.Case
  use QuizBuilders

  alias Mastery.Core.Template

 test "building compiles the raw template" do
  fields = template_fields()
  template = Template.new(fields)

  assert is_nil(Keyword.get(fields, :compiled))
  assert not is_nil(template.compiled)

 end
end
