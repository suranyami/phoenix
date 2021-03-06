defmodule Phoenix.ControllerLoggerTest do
  use ExUnit.Case
  use ConnHelper

  defmodule LoggerController do
    use Phoenix.Controller
    plug :action
    def index(conn, _params), do: text(conn, "index")
  end

  test "verify logger" do
    {_conn, [header, accept, parameters]} = capture_log fn ->
      conn = conn(:get, "/", foo: "bar") |> fetch_params
      LoggerController.call(conn, LoggerController.init(:index))
    end
    assert header =~ "[debug] Processing by Phoenix.ControllerLoggerTest.LoggerController.index"
    assert accept =~ "Accept: text/html"
    assert parameters =~ "Parameters: %{\"foo\" => \"bar\"}"
  end
end
