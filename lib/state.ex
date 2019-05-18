defmodule Veritas.State do
  @moduledoc """
  A strutct that holds all information about the state. 

  %State{state: %{}, metadata: %{}
  State is map that can hold anything.
  Metada holds specific keys.
  iex> %State{state%{}, metadata: %{}}
  %State{state%{}, metadata: %{}}

  iex> State(%{}, %{})
  %State{state%{}, metadata: %{}}

  """
  alias Veritas.State

  defstruct state: %{}, metadata: %{created_at: nil, expires: nil}

  @type t :: %__MODULE__{state: map(), metadata: %{optional(:atom) => term}}

  @doc """
  A constructor for state can reciev a state and options can have expires and recieves and int 

  iex> State.create(%{"test" => 1}, [expires: 5])
  %Veritas.State{
    metadata: %{created_at: #DateTime<2019-05-17 18:14:57.292253Z>, expires: 5},
    state: %{"test" => 1}
  }elixir test for some datatyme get
  iex> State.create(%{"test" => 1})
  %Veritas.State{
    metadata: %{created_at: #DateTime<2019-05-17 18:14:57.292253Z>, expires: nil},
    state: %{"test" => 1}
  }
  iex> State.create()
  %Veritas.State{
    metadata: %{created_at: #DateTime<2019-05-17 18:14:57.292253Z>, expires: nil},
    state: %{}
  }
  """
  def create(state \\ %{}, options \\ []) do
    expires = Keyword.get(options, :expires)

    struct = %State{state: state}
    struct = Map.put(struct, :metadata, Map.put(struct.metadata, :expires, expires))
    Map.put(struct, :metadata, Map.put(struct.metadata, :created_at, DateTime.utc_now()))
  end

  @doc """
  Updates the state it recieve the struct and the new state and it returns a Struct with the new state insted
  """
  @spec update_state(%State{}, map()) :: %State{}
  def update_state(state_struct, new_state) do
    state_struct
    |> Map.put(:state, new_state)
  end

  @doc """
  Return the state of the struct
  """
  @spec get_state(%State{}) :: map
  def get_state(state_struct) do
    state_struct.state
  end

  @doc """
  Return the expiration ttl of the state as an integer 
  """
  @spec get_expiration(%State{}) :: integer() | nil
  def get_expiration(state_struct) do
    state_struct.metadata.expires
  end

  @doc """
  Set expiration ttl time for the state in seconds.
  The expiration times counts after it is set.
  the function return a State struct with the ne expiration
  """
  @spec set_expiration(%State{}, integer()) :: %State{}
  def set_expiration(state_struct, expires) do
    second_difference = DateTime.diff(DateTime.utc_now(), state_struct.metadata.created_at)

    Map.put(
      state_struct,
      :metadata,
      Map.put(state_struct.metadata, :expires, expires + second_difference)
    )
  end

  @doc """
  Cheks if the state has already exired recives State struct and returns a boolean
  """
  @spec has_expire?(%State{}) :: boolean()
  def has_expire?(state_struct) do
    second_difference = DateTime.diff(DateTime.utc_now(), state_struct.metadata.created_at)
    state_struct.metadata.expires <= second_difference
  end

  @doc """
  Check if the parameter is a Veritas State 
  """
  @spec is_state?(%State{}) :: true
  def is_state?(%State{}), do: true
  @spec is_state?(any()) :: false
  def is_state?(_), do: false
end
