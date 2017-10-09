defmodule Gdex.Report do
  alias Gdex.Request

  @type report_type :: :fills | :account
  @type report_opt :: {:product_id, binary}
    | {:account_id, binary}
    | {:format, :pdf | :csv}
    | {:email, binary}

  @doc """
  Create a new report.
  """
  @spec create(report_type, DateTime.t, DateTime.t, [report_opt]) :: Request.t
  def create(type, start_date, end_date, opts \\ []) do
    start_date = DateTime.to_iso8601(start_date)
    end_date = DateTime.to_iso8601(end_date)
    body =
      [type: type, start_date: start_date, end_date: end_date]
      |> Keyword.merge(opts)
    Request.new(:POST, "/reports", body: body)
  end

  @doc """
  Get the status of the report identified by `report_id`.
  """
  @spec status(binary) :: Request.t
  def status(report_id) do
    Request.new(:GET, "/reports/#{report_id}")
  end
end
