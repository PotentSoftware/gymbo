# test/gymbo_web/components/layouts_test.exs
defmodule GymboWeb.Layouts.AppHTMLTest do
  use GymboWeb.ConnCase, async: true

  test "loads root layout" do
    conn = get(build_conn(), "/")
    html = html_response(conn, 200)
    assert html =~ "<html lang=\"en\""
    assert html =~ "<body"
    assert html =~ "csrf-token"
  end

  test "includes necessary meta tags" do
    conn = get(build_conn(), "/")
    html = html_response(conn, 200)
    assert html =~ "<meta charset=\"utf-8\">"
    assert html =~ "<meta name=\"viewport\""
    assert html =~ "<meta name=\"csrf-token\""
  end

  test "includes app title" do
    conn = get(build_conn(), "/")
    html = html_response(conn, 200)
    assert html =~ "<title"
    assert html =~ "Gymbo"
  end
end
