# lib/gymbo_web/controllers/page_controller.ex
defmodule GymboWeb.PageController do
  # This line is crucial - it provides render/3
  use GymboWeb, :controller
  use Gettext, backend: GymboWeb.Gettext

  def home(conn, _params) do
    render(conn, :home, layout: false)
  end
end
