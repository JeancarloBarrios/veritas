defmodule StateTest do
  use ExUnit.Case
  doctest Veritas

  alias Veritas.State
  alias Veritas.Helper

  test "create an empy state with no option parameters" do
    assert State.create().state == %State{}.state
    assert State.create().metadata.expires == %State{}.metadata.expires
    assert Helper.is_a_datetime?(State.create().metadata.created_at)
  end

  test "create an state with initial state" do
    assert State.create(%{"test" => 1}).state == %State{state: %{"test" => 1}}.state
  end

  test "get the state from the state struct" do
    the_state = %{"test" => 1}
    struct_state = State.create(the_state)
    assert State.get_state(struct_state) == the_state
  end

  test "get the state expiration time in seconds" do
    the_state = %{"test" => 1}
    struct_state = State.create(the_state, expires: 10)
    assert State.get_expiration(struct_state) == 10
  end

  test "set new expiration to the state struct" do
    the_state = %{"test" => 1}

    struct_state =
      State.create(the_state)
      |> State.set_expiration(10)

    second_difference = DateTime.diff(DateTime.utc_now(), struct_state.metadata.created_at)
    assert 10 == second_difference + 10
  end

  test "check if state has expire" do
    struct_state =
      State.create()
      |> State.set_expiration(0)

    assert State.has_expire?(struct_state)
  end

  test "check if variable is an state struct" do
    assert State.is_state?(State.create())
    refute State.is_state?("Something Else")
  end
end
