defmodule Keyblade.ReservationSupervisor do
  use Supervisor

  alias Keyblade.Reservations.SearchParams

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children =
      Application.get_env(:keyblade, :searches)
      |> Enum.map(&SearchParams.new/1)
      |> Enum.map(fn search_params ->
        Supervisor.child_spec(
          {Keyblade.ReservationChecker, search_params},
          id: System.unique_integer([:positive])
        )
      end)

    Supervisor.init(children, strategy: :one_for_one)
  end
end
