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

  def delete(key) do
    GenServer.cast(@name, {:delete, key})
  end

  def clear() do
    GenServer.cast(@name, :clear)
  end

  def exist(key) do
    GenServer.call(@name, {:exist, key})
  end



  ##Server API
  def handle_call({:read, key}, _from, state) do
    {:reply, state[key], state}
  end

  def handle_call({:write, key, value}, _from, state) do
    updated = Map.put(state, key, value)
    {:reply, :ok, updated}
  end

  def handle_call({:exist, key}, _from, state) do
    {:reply, Map.has_key?(state, key), state}
  end

  def handle_cast({:delete, key}, state) do
    deleted = Map.delete(state, key)
    {:noreply, deleted}
  end

  def handle_cast(:clear, _state) do
    {:noreply, @initial_state}
  end

  ##Server callbacks
  def init(:ok) do
    {:ok, @initial_state}
  end

end
