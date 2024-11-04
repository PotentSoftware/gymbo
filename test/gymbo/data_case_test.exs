defmodule Gymbo.DataCaseTest do
  use Gymbo.DataCase, async: true

  # Add this line
  use ExUnit.Case

  test "errors_on/2 with empty changeset" do
    changeset = %Ecto.Changeset{errors: []}
    assert errors_on(changeset, :field) == []
  end

  test "errors_on/2 with errors" do
    changeset = %Ecto.Changeset{
      errors: [field: {"is invalid", [validation: :required]}]
    }

    assert errors_on(changeset, :field) == ["is invalid"]
  end
end
