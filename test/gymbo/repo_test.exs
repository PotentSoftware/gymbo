defmodule Gymbo.RepoTest do
  use Gymbo.DataCase
  alias Gymbo.Accounts.User

  describe "basic repository operations" do
    test "can insert and retrieve a record" do
      user_params = %{email: "test@example.com", hashed_password: "somehashedpassword"}

      {:ok, user} =
        %User{}
        |> Ecto.Changeset.cast(user_params, [:email, :hashed_password])
        |> Gymbo.Repo.insert()

      assert Gymbo.Repo.get(User, user.id)
    end

    test "can delete a record" do
      user_params = %{email: "test@example.com", hashed_password: "somehashedpassword"}

      {:ok, user} =
        %User{}
        |> Ecto.Changeset.cast(user_params, [:email, :hashed_password])
        |> Gymbo.Repo.insert()

      assert {:ok, _} = Gymbo.Repo.delete(user)
      refute Gymbo.Repo.get(User, user.id)
    end

    test "can update a record" do
      user_params = %{email: "test@example.com", hashed_password: "somehashedpassword"}

      {:ok, user} =
        %User{}
        |> Ecto.Changeset.cast(user_params, [:email, :hashed_password])
        |> Gymbo.Repo.insert()

      {:ok, updated_user} =
        user
        |> Ecto.Changeset.cast(%{email: "new@example.com"}, [:email])
        |> Gymbo.Repo.update()

      assert updated_user.email == "new@example.com"
    end

    test "can perform a transaction" do
      result =
        Gymbo.Repo.transaction(fn ->
          user_params = %{email: "test@example.com", hashed_password: "somehashedpassword"}

          {:ok, user} =
            %User{}
            |> Ecto.Changeset.cast(user_params, [:email, :hashed_password])
            |> Gymbo.Repo.insert()

          user
        end)

      assert {:ok, %User{}} = result
    end
  end
end
