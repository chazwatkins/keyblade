defmodule Keyblade.Core.Accounts do
  alias Keyblade.Core.Accounts.User

  def list_users do
    config_users = Application.get_env(:keyblade, :users, [])

    Enum.map(config_users, &User.new/1)
  end

  def get_user_by_id(id) do
    list_users()
    |> Enum.filter(fn user -> user.id == id end)
    |> List.first()
  end
end
