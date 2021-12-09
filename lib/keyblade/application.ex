defmodule Keyblade.Application do
  use Application

  @impl true
  def start(_type, _args) do
    install_regulators()

    children = [
      Keyblade.ReservationSupervisor
    ]

    opts = [strategy: :one_for_one, name: Keyblade.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp install_regulators do
    Regulator.install(:disney_world_service, {Regulator.Limit.AIMD, [timeout: 30]})
  end
end
