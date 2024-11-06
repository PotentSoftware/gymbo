defmodule GymboWeb.ErrorHTMLTest do
  use GymboWeb.ConnCase, async: true

  import Phoenix.Template

  test "renders 404.html" do
    assert render_to_string(GymboWeb.ErrorHTML, "404", "html", []) =~ "Not Found"
  end

  test "renders 500.html" do
    assert render_to_string(GymboWeb.ErrorHTML, "500", "html", []) =~ "Internal Server Error"
  end

  test "renders 401.html" do
    assert render_to_string(GymboWeb.ErrorHTML, "401", "html", []) =~ "Unauthorized"
  end

  test "renders 403.html" do
    assert render_to_string(GymboWeb.ErrorHTML, "403", "html", []) =~ "Forbidden"
  end

  test "renders 400.html" do
    assert render_to_string(GymboWeb.ErrorHTML, "400", "html", []) =~ "Bad Request"
  end

  test "renders 422.html" do
    assert render_to_string(GymboWeb.ErrorHTML, "422", "html", []) =~ "Unprocessable Entity"
  end

  test "renders generic error template" do
    assert render_to_string(GymboWeb.ErrorHTML, "custom", "html", []) =~ "Error"
  end

  test "renders with assigns" do
    assigns = [message: "Custom Error Message"]
    assert render_to_string(GymboWeb.ErrorHTML, "404", "html", assigns) =~ "Not Found"
  end

  test "renders with content_type" do
    assert render_to_string(GymboWeb.ErrorHTML, "404", "html", content_type: "text/html") =~
             "Not Found"
  end
end
