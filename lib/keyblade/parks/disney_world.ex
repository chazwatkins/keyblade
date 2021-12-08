defmodule Keyblade.Parks.DisneyWorld do
  require Logger

  defstruct []

  @base_api_url "https://disneyworld.disney.go.com/finder/api/v1/explorer-service/dining-availability/%7B1C0595C5-9A52-49D8-8B20-5C0DE85489BA%7D/wdw"
  @timeout 30_000

  alias __MODULE__
  alias Keyblade.Parks.Query
  alias Keyblade.Reservations.SearchParams
  alias Keyblade.Reservations.ReservationTime

  defimpl Keyblade.Parks do
    def check_for_available_reservations(_provider, search_params) do
      DisneyWorld.check_for_available_reservations(search_params)
    end
  end

  def check_for_available_reservations(search_params) do
    search_params
    |> build_queries()
    |> run_queries()
    |> maybe_send_notification()
  end

  def maybe_send_notification(%SearchParams{
        queries: queries,
        restaurant_name: restaurant_name,
        notify_number: notify_number
      }) do
    queries
    |> Stream.filter(fn query -> query.reservation_times != [] end)
    |> Stream.flat_map(&Map.get(&1, :reservation_times))
    |> build_sms_message(restaurant_name)
    |> Keyblade.SMS.send(notify_number)
  end

  def build_sms_message(reservation_times, restaurant_name) do
    reservation_time_strings =
      reservation_times
      |> Stream.map(&reservation_time_to_string/1)
      |> Enum.join("\n")

    restaurant_name <> "\n\n" <> reservation_time_strings
  end

  def reservation_time_to_string(%ReservationTime{datetime: datetime, party_size: party_size}) do
    date = Timex.format!(datetime, "%F", :strftime)
    {hour, time_of_day} = Timex.Time.to_12hour_clock(datetime.hour)
    "#{date} @ #{hour}:#{datetime.minute} #{time_of_day} - Party of #{party_size}"
  end

  defp run_queries(%SearchParams{queries: queries} = search_params) do
    Logger.info("Running queries")

    queries
    |> Task.async_stream(&run_query/1, timeout: @timeout)
    |> Stream.filter(&match?({:ok, _}, &1))
    |> Stream.flat_map(fn {:ok, result} -> result end)
    |> Enum.to_list()
    |> then(&Map.put(queries, :reservation_times, &1))
    |> then(&Map.put(search_params, :queries, &1))
  end

  defp get_offers(%{body: body}) when is_map(body) do
    Map.get(body, "offers", [])
  end

  defp get_offers(_response) do
    []
  end

  defp run_query(%Query{query_string: query_string, party_size: party_size}) do
    query_string
    |> Req.get!(receive_timeout: @timeout)
    |> get_offers()
    |> Enum.map(&build_reservation_time(&1, party_size))
  end

  defp build_reservation_time(offer, party_size) do
    datetime =
      offer
      |> Map.get("dateTime")
      |> Timex.parse!("%FT%T%:z", :strftime)

    ReservationTime.new(%{
      datetime: datetime,
      part_size: party_size
    })
  end

  def build_queries(search_params) do
    Logger.info("Building queries for restaurant #{search_params.restaurant_id}")
    date_range = Date.range(search_params.start_date, search_params.end_date)
    party_range = search_params.party_size_min..search_params.party_size_max

    for date <- date_range, party_size <- party_range do
      start_datetime = DateTime.new!(date, search_params.start_time)
      end_datetime = DateTime.new!(date, search_params.end_time)

      time_interval =
        Timex.Interval.new(
          from: start_datetime,
          until: end_datetime,
          step: [hours: 1]
        )

      for time <- time_interval do
        query =
          Query.new(%{
            restaurant_id: search_params.restaurant_id,
            party_size: party_size,
            date: Date.to_string(date),
            time: Timex.format!(time, "%H:%M:%S", :strftime)
          })

        query_string = build_query_string(query)
        Map.put(query, :query_string, query_string)
      end
    end
    |> List.flatten()
    |> then(&Map.put(search_params, :queries, &1))
  end

  defp build_query_string(query) do
    @base_api_url
    |> add_restaurant_id(query)
    |> add_party_size(query)
    |> add_date(query)
    |> add_time(query)
  end

  defp add_restaurant_id(query, %{restaurant_id: restaurant_id}) do
    query <> "/#{restaurant_id};entityType=restaurant/table-service"
  end

  defp add_party_size(query, %{party_size: party_size}) do
    query <> "/#{party_size}"
  end

  defp add_date(query, %{date: date}) do
    query <> "/#{date}"
  end

  defp add_time(query, %{time: time}) do
    query <> "/?searchTime=#{time}"
  end
end
