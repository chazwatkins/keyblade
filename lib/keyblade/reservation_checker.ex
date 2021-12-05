defmodule Keyblade.ReservationChecker do
  use GenServer

  alias Keyblade.Parks.DisneyWorld
  alias Keyblade.Reservations.SearchParams

  def start_link(_arg) do
    search_params = %SearchParams{
      start_date: Date.new!(2022, 01, 13),
      end_date: Date.new!(2022, 01, 18),
      start_time: Time.new!(15, 30, 0),
      end_time: Time.new!(21, 15, 0),
      party_size_min: 4,
      party_size_max: 8
    }

    GenServer.start_link(__MODULE__, search_params)
  end

  @impl true
  def init(search_params) do
    IO.puts("Initializing #{__MODULE__}")
    send(self(), :check_reservations)
    {:ok, search_params}
  end

  @impl true
  def handle_info(:check_reservations, search_params) do
    IO.puts("Checking for reservations")
    Keyblade.check_for_available_reservations(%DisneyWorld{}, search_params)
    IO.puts("Finished checking for reservations")

    schedule_work()
    {:noreply, search_params}
  end

  def schedule_work do
    IO.puts("Scheduling next reservation check")
    Process.send_after(self(), :check_reservations, :timer.minutes(30))
  end
end
