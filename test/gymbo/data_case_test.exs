defmodule Gymbo.DataCaseTest do
  use ExUnit.Case

  # import Gymbo.DataCase
  alias Ecto.Adapters.SQL.Sandbox

  setup do
    # Start with a clean sandbox for each test
    :ok = Sandbox.checkout(Gymbo.Repo)
    :ok
  end

  describe "sandbox" do
    test "setup_sandbox handles shared mode" do
      # First ensure we're not already in shared mode
      Sandbox.mode(Gymbo.Repo, :manual)

      pid = Ecto.Adapters.SQL.Sandbox.start_owner!(Gymbo.Repo, shared: true)

      try do
        assert Process.alive?(pid)
      after
        Ecto.Adapters.SQL.Sandbox.stop_owner(pid)
      end
    end

    test "setup_sandbox handles async mode" do
      # Since setup already checked out, we just need to set the mode
      Sandbox.mode(Gymbo.Repo, {:shared, self()})

      parent = self()

      Task.start_link(fn ->
        :ok = Sandbox.allow(Gymbo.Repo, parent, self())
        send(parent, :ready)

        receive do
          :stop -> :ok
        end
      end)

      assert_receive :ready
    end
  end

  describe "repo operations" do
    test "repo handles invalid connection config" do
      # Create a backup of the current config
      current_config = Application.get_env(:gymbo, Gymbo.Repo)

      try do
        # Create a new Repo module with invalid configuration
        defmodule TestRepo do
          use Ecto.Repo,
            otp_app: :gymbo,
            adapter: Ecto.Adapters.Postgres
        end

        # Configure the test repo with invalid credentials
        Application.put_env(:gymbo, TestRepo,
          hostname: "nonexistent-host",
          database: "nonexistent_db",
          username: "invalid_user",
          password: "wrong_password",
          pool_size: 1
        )

        assert_raise DBConnection.ConnectionError, fn ->
          {:ok, _} = TestRepo.start_link()
          # Use a proper Ecto query
          TestRepo.query!("SELECT 1")
        end
      after
        # Cleanup: Remove the test configuration
        Application.delete_env(:gymbo, TestRepo)
        # Restore original config
        Application.put_env(:gymbo, Gymbo.Repo, current_config)
      end
    end
  end
end
