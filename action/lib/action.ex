defmodule Action do
  alias Action.{Open, Call, Check, Raise}
  defdelegate open_bet(table_state, seat, value), to: Open
  defdelegate place_call(table_state, seat), to: Call
  defdelegate check(table_state, seat), to: Check
  defdelegate raise_bet(table_state, seat, value), to: Raise
end
