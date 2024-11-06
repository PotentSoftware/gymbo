defmodule GymboWeb.CoreComponentsTest do
  use GymboWeb.ConnCase, async: true
  import Phoenix.LiveViewTest
  import GymboWeb.CoreComponents

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

  test "renders checkbox input" do
    html =
      render_component(&input/1, %{
        type: "checkbox",
        name: "terms",
        label: "Accept terms",
        checked: true
      })

    assert html =~ "type=\"checkbox\""
    assert html =~ "checked"
    assert html =~ "Accept terms"
  end

  test "renders select input" do
    html =
      render_component(&input/1, %{
        type: "select",
        name: "country",
        label: "Country",
        prompt: "Choose a country",
        options: ["USA", "Canada", "UK"],
        value: "USA"
      })

    assert html =~ "<select"
    assert html =~ "Choose a country"
    assert html =~ "USA"
    assert html =~ "Canada"
    assert html =~ "UK"
  end

  test "renders textarea input" do
    html =
      render_component(&input/1, %{
        type: "textarea",
        name: "description",
        label: "Description",
        value: "Test description"
      })

    assert html =~ "<textarea"
    assert html =~ "Test description"
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

  test "renders modal component" do
    html =
      render_component(&modal/1, %{
        id: "test-modal",
        show: true,
        inner_block: [%{inner_block: fn _, _ -> "Modal Content" end}]
      })

    assert html =~ "test-modal"
    assert html =~ "Modal Content"
    assert html =~ "aria-modal=\"true\""
  end

  test "renders flash component" do
    html =
      render_component(&flash/1, %{
        kind: :info,
        title: "Success",
        flash: %{"info" => "Operation successful"},
        inner_block: [%{inner_block: fn _, _ -> "Operation successful" end}]
      })

    assert html =~ "Success"
    assert html =~ "Operation successful"
    assert html =~ "hero-information-circle-mini"
  end

  test "renders flash_group component" do
    html =
      render_component(&flash_group/1, %{
        flash: %{"info" => "Success message", "error" => "Error message"}
      })

    assert html =~ "Success message"
    assert html =~ "Error message"
    assert html =~ "Success!"
    assert html =~ "Error!"
  end

  test "renders label component" do
    html =
      render_component(&label/1, %{
        for: "test-input",
        inner_block: [%{inner_block: fn _, _ -> "Test Label" end}]
      })

    assert html =~ "for=\"test-input\""
    assert html =~ "Test Label"
  end

  test "renders header component" do
    html =
      render_component(&header/1, %{
        class: "custom-header",
        inner_block: [%{inner_block: fn _, _ -> "Header Title" end}],
        subtitle: [%{inner_block: fn _, _ -> "Subtitle" end}],
        actions: [%{inner_block: fn _, _ -> "<button>Action</button>" end}]
      })

    assert html =~ "Header Title"
    assert html =~ "Subtitle"
    assert html =~ "&lt;button&gt;Action&lt;/button&gt;"
    assert html =~ "custom-header"
  end

  test "renders icon component" do
    html = render_component(&icon/1, %{name: "hero-x-mark-solid", class: "custom-icon"})
    assert html =~ "hero-x-mark-solid"
    assert html =~ "custom-icon"
  end

  test "translate_error handles count option" do
    assert translate_error({"has %{count} items", count: 3}) =~ "has 3 items"
  end

  test "translate_error handles regular message" do
    assert translate_error({"is invalid", []}) =~ "is invalid"
  end

  test "translate_errors returns list of translated errors" do
    errors = [email: {"is invalid", []}]
    assert translate_errors(errors, :email) == ["is invalid"]
  end

  describe "JS commands" do
    test "show/1 returns proper JS command" do
      js = show("#test")
      assert [["show", %{to: "#test", transition: transition}]] = js.ops
      assert is_list(transition)
      assert length(transition) == 3
      assert Enum.at(transition, 0) == ["transition-all", "transform", "ease-out", "duration-300"]
    end

    test "hide/1 returns proper JS command" do
      js = hide("#test")
      assert [["hide", %{to: "#test", transition: transition}]] = js.ops
      assert is_list(transition)
      assert length(transition) == 3
      assert Enum.at(transition, 0) == ["transition-all", "transform", "ease-in", "duration-200"]
    end

    test "show_modal/1 returns proper JS commands" do
      js = show_modal("test-modal")
      # Show modal, show bg, show container, add class, focus
      assert length(js.ops) == 5
      assert Enum.any?(js.ops, fn op -> match?(["show", %{to: "#test-modal"}], op) end)
    end

    test "hide_modal/1 returns proper JS commands" do
      js = hide_modal("test-modal")
      # Hide bg, hide container, hide modal, remove class, pop focus
      assert length(js.ops) == 5
      assert Enum.any?(js.ops, fn op -> match?(["hide", %{to: "#test-modal"}], op) end)
    end
  end
end
