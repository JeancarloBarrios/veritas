defmodule Veritas.Helper do
  def is_a_datetime?(%DateTime{}) do
    true
  end

  def is_a_datetime?(_) do
    false
  end
end
