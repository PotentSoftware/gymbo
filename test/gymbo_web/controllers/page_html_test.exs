defmodule GymboWeb.PageHTMLTest do
  use GymboWeb.ConnCase, async: true

  test "home.html renders main sections" do
    conn = get(build_conn(), "/")
    html = html_response(conn, 200)

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
    conn = get(build_conn(), "/")
    html = html_response(conn, 200)

    assert html =~ ~s(href="/users/register")
    assert html =~ ~s(href="/users/log_in")
  end

  test "home.html renders with proper styling classes" do
    conn = get(build_conn(), "/")
    html = html_response(conn, 200)

    assert html =~ ~s(class="grid grid-cols-1 md:grid-cols-2 gap-8")
    assert html =~ ~s(class="bg-zinc-800 p-8 rounded-lg")
    assert html =~ ~s(class="text-2xl font-bold mb-4")
    assert html =~ ~s(class="text-gray-300 mb-6")
    assert html =~ ~s(class="auth-button inline-block")
  end

  test "home.html includes flash group component" do
    conn = get(build_conn(), "/")
    html = html_response(conn, 200)

    assert html =~ ~s(id="flash-group")
  end

  test "home.html renders responsive grid layout" do
    conn = get(build_conn(), "/")
    html = html_response(conn, 200)

    # Check grid classes for responsive design
    assert html =~ "grid-cols-1"
    assert html =~ "md:grid-cols-2"
  end
end
