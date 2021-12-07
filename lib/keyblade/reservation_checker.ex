defmodule Keyblade.ReservationChecker do
  use GenServer
  require Logger

  alias Keyblade.Parks.DisneyWorld

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
    Logger.info("Checking reservations for #{search_params.restaurant_id}")
    Keyblade.check_for_available_reservations(%DisneyWorld{}, search_params)
    Logger.info("Finished checking reservations for #{search_params.restaurant_id}")

    schedule_work()
    {:noreply, search_params}
  end

  def schedule_work do
    Logger.info("Next reservation check scheduled")
    Process.send_after(self(), :check_reservations, :timer.minutes(15))
  end
end
