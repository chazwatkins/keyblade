defmodule Keyblade.ReservationChecker do
  use GenServer
  require Logger

  alias Keyblade.Parks.DisneyWorld
  alias Keyblade.Reservations.SearchParams
  alias Keyblade.Accounts
  alias Keyblade.Entities

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

    user = Accounts.get_user_by_id(search_params.user_id)
    restaurant = Entities.get_restaurant_by_id(search_params.restaurant_id)

    Logger.info(
      "Checking reservations for #{restaurant.name} - User: #{user.name} #{user.phone_number}"
    )

    Keyblade.check_for_available_reservations(%DisneyWorld{}, search_params, restaurant, user)

    Logger.info(
      "Finished checking reservations for #{restaurant.name} - User: #{user.name} #{user.phone_number}"
    )

    schedule_work(search_params)
    {:noreply, search_params}
  end

  def schedule_work(%SearchParams{
        interval: interval
      }) do
    next_interval_timer = apply(:timer, interval.measure, [interval.length])
    Process.send_after(self(), :check_reservations, next_interval_timer)
  end
end
