defmodule Keyblade.Parks.DisneyWorld do
  @base_api_url "https://disneyworld.disney.go.com/finder/api/v1/explorer-service/dining-availability/%7B1C0595C5-9A52-49D8-8B20-5C0DE85489BA%7D/wdw"

  defstruct []

  alias __MODULE__
  alias Keyblade.Parks.QueryParams

  defimpl Keyblade.Parks do
    def check_for_available_reservations(_provider, search_params) do
      DisneyWorld.check_for_available_reservations(search_params)
    end
  end

  def check_for_available_reservations(search_params) do
    search_params
    |> build_initial_queries()
    |> run_queries()
    |> maybe_send_sms()
  end

  def maybe_send_sms(query_results) do
    if(query_results != []) do
      message = build_sms_message(query_results)

      if message != "" do
        Logger.info("Sending available reservations SMS")
        Keyblade.SMS.send(message)
      end
    else
      Logger.info("No available reservations found")
    end
  end

  def build_sms_message(query_results) do
    query_results
    |> Enum.map(&datetime_to_formatted_string/1)
    |> Enum.join("\n")
  end

  def datetime_to_formatted_string(%{"dateTime" => datetime}) do
    parsed_datetime = Timex.parse!(datetime, "%FT%T%:z", :strftime)
    date = Timex.format!(parsed_datetime, "%F", :strftime)
    {hour, time_of_day} = Timex.Time.to_12hour_clock(parsed_datetime.hour)
    "#{date} @ #{hour}:#{parsed_datetime.minute} #{time_of_day}"
  end

  defp run_queries(queries) do
    Logger.info("Running queries")
    Enum.flat_map(queries, &run_query/1)
  end

  defp run_query(query) do
    query
    |> Req.get!()
    |> Map.get(:body)
    |> Map.get("offers", [])
  end

  def build_initial_queries(search_params) do
    Logger.info("Building queries")
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
        query_params =
          QueryParams.new(%{
            restaurant_id: 90_002_606,
            party_size: party_size,
            date: Date.to_string(date),
            time: Timex.format!(time, "%H:%M:%S", :strftime)
          })

        build_query(query_params)
      end
    end
    |> List.flatten()
  end

  defp build_query(query_params) do
    @base_api_url
    |> add_restaurant_id(query_params)
    |> add_party_size(query_params)
    |> add_date(query_params)
    |> add_time(query_params)
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
