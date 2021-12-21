defmodule Keyblade.ReservationChecker do
  use GenServer
  require Logger

  alias Keyblade.Parks.DisneyWorld
  alias Keyblade.Reservations.SearchParams

  def start_link(search_params) do
    GenServer.start_link(__MODULE__, search_params)
  end

  @impl true
  def init(search_params) do
    send(self(), :check_reservations)
    {:ok, search_params}
  end

  @impl true
  def handle_info(:check_reservations, search_params) do
    search_params =
      search_params
      |> Map.put(:queries, [])
      |> Map.put(:reservation_times, [])

    Logger.info(
      "Checking reservations for #{search_params.restaurant_name} - User: #{search_params.notify_number}"
    )

    Keyblade.check_for_available_reservations(%DisneyWorld{}, search_params)

    Logger.info(
      "Finished checking reservations for #{search_params.restaurant_name} - User: #{search_params.notify_number}"
    )

    schedule_work(search_params)
    {:noreply, search_params}
  end

  def schedule_work(%SearchParams{
        interval: interval,
        restaurant_name: restaurant_name,
        notify_number: notify_number
      }) do
    Logger.info(
      "Next reservation check scheduled for #{restaurant_name} - User: #{notify_number}"
    )

    next_interval_timer = apply(:timer, interval.measure, [interval.length])
    Process.send_after(self(), :check_reservations, next_interval_timer)
  end
end
