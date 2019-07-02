defmodule Action.Call do
  alias Action.Helpers

  def place_call(%{bet_to_call: nil} = table_state, _seat) do
    IO.puts("No bet to call")
    table_state
  end

  def place_call(
        %{seat_with_action: seat_with_action, status: :action_opened} = table_state,
        seat
      ) do
    correct_turn? = seat == seat_with_action
    place_call(table_state, seat, correct_turn?)
  end

  def place_call(table_state, _seat) do
    IO.puts("Table not expecting call action")
    table_state
  end

  def place_call(table_state, _seat, false = _correct_turn?) do
    IO.puts("Seat attempting to call out of turn")
    table_state
  end

  def place_call(
        %{seat_map: seat_map, bet_to_call: bet_to_call} = table_state,
        seat,
        true = _correct_turn?
      ) do
    already_commited = seat_map[seat].chips_to_pot_current_bet_round
    remaining_to_call = bet_to_call - already_commited

    player =
      seat_map[seat]
      |> Player.commit_chips_to_pot(remaining_to_call)

    %{table_state | seat_map: Map.put(seat_map, seat, player)}
    |> Helpers.check_end_action()
  end
end
