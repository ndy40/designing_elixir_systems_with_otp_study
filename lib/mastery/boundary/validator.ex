defmodule Mastery.Boundary.Validator do
  def require(errors, fields, field_name, validator) do
    present = Map.has_key?(fields, field_name)
    check_required_fields(present, fields, errors, field_name, validator)
  end

  def optional(errors, fields, field_name, validator) do
    if Map.has_key?(fields, field_name) do
      require(errors, fields, field_name, validator)
    else
      errors
    end
  end

  def check(true=_valid, _message), do: :ok
  def check(false=_invalid, message), do: message

  defp check_required_fields(true=_present, fields, errors, field_name, f) do
    valid = fields |> Map.fetch!(field_name) |> f.()
    check_field(valid, errors, field_name)
  end
  defp check_required_fields(_present, _fields, errors, field_name, _f) do
    errors ++ [{field_name, "is required"}]
  end

  defp check_field(:ok, _errors, _field_name), do: :ok
  defp check_field({:error, message}, errors, field_name) do
    errors ++ [{field_name, message}]
  end
  defp check_field({:errors, messages}, errors, field_name) do
    errors ++ Enum.map(messages, &{field_name, &1})
  end

  def validate_title(title) when is_binary(title) do
    check(String.match?(title, ~r{\S}), {:error, "can't be blank"})
  end

  def validate_title(_title), do: {:error, "must be a string"}
  def validate_mastery(mastery) when is_integer(mastery) do
    check(mastery >= 1, {:error, "must be greater than zero"})
  end
  def validate_mastery(_mastery), do: {:error, "must be an integer"}
end
