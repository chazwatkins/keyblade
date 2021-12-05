defmodule Keyblade.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Keyblade.ReservationChecker
    ]

    opts = [strategy: :one_for_one, name: Keyblade.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
