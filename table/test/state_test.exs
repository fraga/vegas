defmodule StateTest do
  use ExUnit.Case
  doctest Table.State

  alias Table.{State, Player}

  test "creates a table given a table id" do
    table = State.new()

    assert table.status == :waiting
    assert Enum.count(table.deck) == 52
    assert Enum.count(table.seat_map) == 10

    for seat <- 1..10 do
      assert table.seat_map[seat] == :empty_seat
    end
  end

  test "moves dealer seat, does not move if not integer or if index > 10" do
    table = State.new()
    assert table.dealer_seat == nil

    table =
      table
      |> State.move_dealer_to_seat(3)

    assert table.dealer_seat == 3

    table =
      table
      |> State.move_dealer_to_seat("not an integer")

    assert table.dealer_seat == 3

    table =
      table
      |> State.move_dealer_to_seat(11)

    assert table.dealer_seat == 3
  end

  test "moves dealer seat to left, moves to one if current index is 10" do
    table = State.new()

    table =
      table
      |> State.move_dealer_to_left()

    assert table.dealer_seat == nil

    table =
      table
      |> State.move_dealer_to_seat(9)

    assert table.dealer_seat == 9

    table =
      table
      |> State.move_dealer_to_left()

    assert table.dealer_seat == 10

    table =
      table
      |> State.move_dealer_to_left()

    assert table.dealer_seat == 1
  end

  test "player joins cannot join taken seat" do
    table = State.new()
    player = Player.new("Danilo", 200)

    {status, table} = State.join_table(table, player, 2)

    assert status == :ok
    assert table.seat_map[2] == player

    player_two = Player.new("Paula", 200)
    {status, table} = State.join_table(table, player_two, 2)

    assert status == :seat_taken
    assert table.seat_map[2] == player
  end

  test "player leaves" do
    table = State.new()
    player = Player.new("Danilo", 200)

    {status, table} = State.join_table(table, player, 2)

    assert status == :ok
    assert table.seat_map[2] == player

    table = State.leave_table(table, 2)

    assert table.seat_map[2] == :empty_seat
  end
end
