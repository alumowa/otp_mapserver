defmodule OtpMapserver do

  use GenServer

  @name OTPMS
  @initial_state %{}

  ##Client API
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts ++ [name: OTPMS])
  end

  def read(key) do
    GenServer.call(@name, {:read, key})
  end

  def write(key, value) do
    GenServer.call(@name, {:write, key, value})
  end

  ##Server API
  def handle_call({:read, key}, _from, state) do
    {:reply, state[key], state}
  end

  def handle_call({:write, key, value}, _from, state) do
    updated = Map.put(state, key, value)
    {:reply, :ok, updated}
  end

  ##Server callbacks
  def init(:ok) do
    {:ok, @initial_state}
  end

  ##Helper function

end
