defmodule GymboWeb.CoreComponentsTest do
  use GymboWeb.ConnCase, async: true
  import Phoenix.LiveViewTest
  import GymboWeb.CoreComponents

  @doc """
  Renders an error message.
  """
  test "renders button component" do
    html =
      render_component(&button/1, %{
        type: "submit",
        class: "custom-class",
        inner_block: [%{inner_block: fn _, _ -> "Submit" end}]
      })

    assert html =~ "type=\"submit\""
    assert html =~ "custom-class"
    assert html =~ "Submit"
  end

  test "renders input component" do
    html =
      render_component(&input/1, %{
        type: "text",
        name: "username",
        value: "test",
        class: "input-class"
      })

    assert html =~ "type=\"text\""
    assert html =~ "name=\"username\""
    assert html =~ "value=\"test\""
    assert html =~ "input-class"
  end

  test "renders simple_form component" do
    html =
      render_component(&simple_form/1, %{
        for: %{},
        as: :user,
        action: "/users",
        inner_block: [%{inner_block: fn _, _ -> "Form Content" end}]
      })

    assert html =~ "action=\"/users\""
    assert html =~ "Form Content"
  end

  test "renders error component" do
    html =
      render_component(&error/1, %{
        errors: ["can't be blank"],
        inner_block: [%{inner_block: fn _, _ -> "can't be blank" end}]
      })

    assert html =~ ~s(<p class="flex-1">can&#39;t be blank</p>)
    assert html =~ "hero-exclamation-circle-mini"
  end

  test "renders table component" do
    assigns = %{
      rows: [%{id: 1, name: "Test"}],
      row_id: fn row -> "row-#{row.id}" end,
      row_item: fn row -> row.name end,
      col: "test-col"
    }

    html = render_component(&table/1, assigns)
    assert html =~ ~s(class="test-col")
    assert html =~ "Test"
    assert html =~ ~s(id="row-1")
  end
end
