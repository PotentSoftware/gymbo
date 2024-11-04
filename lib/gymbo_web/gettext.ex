# lib/gymbo_web/gettext.ex
defmodule GymboWeb.Gettext do
  @moduledoc """
  A module providing Internationalization with a gettext-based API.
  """

  # Use the new recommended syntax for defining the backend
  use Gettext.Backend, otp_app: :gymbo
end

# Update any files that import GymboWeb.Gettext to use:
# use Gettext, backend: GymboWeb.Gettext
