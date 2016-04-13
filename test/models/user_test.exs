defmodule Rumbl.UserTest do
  use Rumbl.ModelCase, async: true
  alias Rumbl.User

  @valid_attrs %{name: "A User", username: "Eva", password: "secret"}
  @invalid_attrs %{}

  test "changeset with valid_attrs" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid_attrs" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset does not accept long usernames" do
    attrs = Map.put(@valid_attrs, :username, String.duplicate("a", 30))
    assert{:username, {"should be at most %{count} character(s)", [count: 20]}} in
      errors_on(%User{}, attrs)
  end
end
