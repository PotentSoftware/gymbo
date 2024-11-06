defmodule GymboWeb.LayoutsTest do
  use GymboWeb.ConnCase, async: true

  import Gymbo.AccountsFixtures
  # import Phoenix.Component
  import Phoenix.LiveViewTest
  import GymboWeb.UserAuth

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

  test "root layout renders auth navigation for logged out users" do
    conn = get(build_conn(), "/")
    html = html_response(conn, 200)

    # Check navigation elements for logged out users
    assert html =~ ~s(href="/users/register")
    assert html =~ ~s(href="/users/log_in")
    assert html =~ "Register"
    assert html =~ "Log in"
    refute html =~ "Settings"
    refute html =~ "Log out"
  end

  test "root layout renders auth navigation for logged in users" do
    user = user_fixture()
    token = Gymbo.Accounts.generate_user_session_token(user)

    conn =
      build_conn()
      |> init_test_session(%{})
      # Add the session token
      |> put_session(:user_token, token)
      # This will now find the user via token
      |> fetch_current_user([])
      |> get("/")

    html = html_response(conn, 200)

    assert html =~ user.email
    assert html =~ ~s(href="/users/settings")
    assert html =~ ~s(href="/users/log_out")
    assert html =~ "Settings"
    assert html =~ "Log out"
    refute html =~ "Register"
    refute html =~ "Log in"
  end

  # test "root layout renders auth navigation for logged in users" do
  #   user = user_fixture()

  #   conn =
  #     build_conn()
  #     |> Plug.Conn.assign(:current_user, user)
  #     |> get("/")

  #   html = html_response(conn, 200)

  #   # Check navigation elements for logged in users
  #   assert html =~ user.email
  #   assert html =~ ~s(href="/users/settings")
  #   assert html =~ ~s(href="/users/log_out")
  #   assert html =~ "Settings"
  #   assert html =~ "Log out"
  #   refute html =~ "Register"
  #   refute html =~ "Log in"
  # end

  test "root layout includes custom styling" do
    conn = get(build_conn(), "/")
    html = html_response(conn, 200)

    assert html =~ "--primary-red: #ff4136"
    assert html =~ "--dark-gray: #2b2b2b"
    assert html =~ "--light-gray: #f4f4f4"
    assert html =~ "auth-button"
    assert html =~ "gym-header"
  end

  test "app layout renders with flash group" do
    assigns = %{
      flash: %{"info" => "Test flash"},
      inner_content: "Test Content"
    }

    html = rendered_to_string(GymboWeb.Layouts.app(assigns))
    assert html =~ "Test Content"
    assert html =~ "flash-group"
  end

  test "app layout includes max width container" do
    assigns = %{
      flash: %{},
      inner_content: "Test Content"
    }

    html = rendered_to_string(GymboWeb.Layouts.app(assigns))
    assert html =~ ~s(class="mx-auto max-w-2xl")
  end

  test "app layout renders inner content" do
    assigns = %{
      flash: %{},
      inner_content: "Test Content"
    }

    html = rendered_to_string(GymboWeb.Layouts.app(assigns))
    assert html =~ "Test Content"
  end

  test "app layout renders without flash messages" do
    assigns = %{
      flash: %{},
      inner_content: "Test Content"
    }

    html = rendered_to_string(GymboWeb.Layouts.app(assigns))
    assert html =~ "<div id=\"flash-group\">"
    refute html =~ "Test flash"
  end

  test "root layout includes proper language and scrollbar settings" do
    conn = get(build_conn(), "/")
    html = html_response(conn, 200)

    assert html =~ ~s(<html lang="en")
    assert html =~ ~s([scrollbar-gutter:stable])
  end

  test "root layout renders body with proper styling" do
    conn = get(build_conn(), "/")
    html = html_response(conn, 200)

    assert html =~ "background-color: var(--dark-gray)"
    assert html =~ "color: white"
  end
end
