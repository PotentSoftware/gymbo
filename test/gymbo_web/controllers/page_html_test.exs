defmodule GymboWeb.PageHTMLTest do
  use GymboWeb.ConnCase, async: true
  # import Phoenix.Component
  import Phoenix.LiveViewTest

  test "home.html renders main sections" do
    assigns = %{flash: %{}}
    html = render_component(&GymboWeb.PageHTML.home/1, assigns)

    # First section
    assert html =~ "Start Your Fitness Journey"
    assert html =~ "Whether you're a beginner or an experienced athlete"
    assert html =~ "Join Now"

    # Second section
    assert html =~ "Book Your Sessions"
    assert html =~ "Flexible scheduling that fits your lifestyle"
    assert html =~ "Schedule Workout"
  end

  test "home.html includes registration and login links" do
    assigns = %{flash: %{}}
    html = render_component(&GymboWeb.PageHTML.home/1, assigns)

    assert html =~ ~s(href="/users/register")
    assert html =~ ~s(href="/users/log_in")
  end

  test "home.html renders with proper styling classes" do
    assigns = %{flash: %{}}
    html = render_component(&GymboWeb.PageHTML.home/1, assigns)

    assert html =~ ~s(class="grid grid-cols-1 md:grid-cols-2 gap-8")
    assert html =~ ~s(class="bg-zinc-800 p-8 rounded-lg")
    assert html =~ ~s(class="text-2xl font-bold mb-4")
    assert html =~ ~s(class="text-gray-300 mb-6")
    assert html =~ ~s(class="auth-button inline-block")
  end

  test "home.html includes flash group component" do
    assigns = %{flash: %{"info" => "Test flash message"}}
    html = render_component(&GymboWeb.PageHTML.home/1, assigns)

    assert html =~ "flash-group"
    assert html =~ "Test flash message"
  end

  test "home.html renders responsive grid layout" do
    assigns = %{flash: %{}}
    html = render_component(&GymboWeb.PageHTML.home/1, assigns)

    # Check grid classes for responsive design
    assert html =~ "grid-cols-1"
    assert html =~ "md:grid-cols-2"
  end

  test "home.html renders with empty flash" do
    assigns = %{flash: %{}}
    html = render_component(&GymboWeb.PageHTML.home/1, assigns)

    assert html =~ "<div id=\"flash-group\">"
  end

  test "home.html renders with flash messages" do
    assigns = %{flash: %{"info" => "Success!", "error" => "Error!"}}
    html = render_component(&GymboWeb.PageHTML.home/1, assigns)

    assert html =~ "Success!"
    assert html =~ "Error!"
  end

  test "home.html renders with proper HTML structure" do
    assigns = %{flash: %{}}
    html = render_component(&GymboWeb.PageHTML.home/1, assigns)

    assert html =~ "<div class=\"grid grid-cols-1 md:grid-cols-2 gap-8\">"
    assert html =~ "<div class=\"bg-zinc-800 p-8 rounded-lg\">"
    assert html =~ "<h2 class=\"text-2xl font-bold mb-4\">"
    assert html =~ "<p class=\"text-gray-300 mb-6\">"
  end
end
