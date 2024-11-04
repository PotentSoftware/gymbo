defmodule GymboWeb.LayoutsTest do
  use GymboWeb.ConnCase, async: true

  test "root layout renders page title" do
    conn = get(build_conn(), "/")
    assert html_response(conn, 200) =~ "<title>Gymbo · Fitness For Everyone</title>"
  end

  test "root layout renders page title with custom value" do
    conn =
      build_conn()
      |> Plug.Conn.assign(:page_title, "Custom Title")
      |> get("/")

    assert html_response(conn, 200) =~ "<title>Custom Title · Fitness For Everyone</title>"
  end

  test "root layout includes required meta tags and assets" do
    conn = get(build_conn(), "/")
    html = html_response(conn, 200)

    # Check meta tags
    assert html =~ ~s(<meta charset="utf-8")
    assert html =~ ~s(<meta name="viewport" content="width=device-width)
    assert html =~ ~s(<meta name="csrf-token")

    # Check assets
    assert html =~ ~s(href="/assets/app.css")
    assert html =~ ~s(src="/assets/app.js")
  end

  test "root layout includes gym header" do
    conn = get(build_conn(), "/")
    html = html_response(conn, 200)

    assert html =~ ~s(<h1 class="gym-title">Gymbo</h1>)
    assert html =~ ~s(<p class="gym-subtitle">Book Your Workout Time. Transform Your Life.</p>)
  end

  test "app layout renders auth navigation" do
    conn = get(build_conn(), "/")
    html = html_response(conn, 200)

    # Check navigation elements
    assert html =~ ~s(href="/users/register")
    assert html =~ ~s(href="/users/log_in")
    assert html =~ "Register"
    assert html =~ "Log in"
  end

  test "app layout includes flash group" do
    conn =
      build_conn()
      |> init_test_session(%{})
      |> fetch_flash()
      |> put_flash(:info, "Test flash message")
      |> get("/")

    html = html_response(conn, 200)
    assert html =~ "Test flash message"
  end

  test "app layout includes custom styling" do
    conn = get(build_conn(), "/")
    html = html_response(conn, 200)

    assert html =~ "--primary-red: #ff4136"
    assert html =~ "--dark-gray: #2b2b2b"
    assert html =~ "--light-gray: #f4f4f4"
  end
end
