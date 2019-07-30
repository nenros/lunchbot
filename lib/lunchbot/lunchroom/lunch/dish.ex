defmodule Lunchbot.Lunchroom.Lunch.Dish do
  defstruct [:name, :details, :image]

  defimpl String.Chars do
    def to_string(%Lunchbot.Lunchroom.Lunch.Dish{name: name, details: details}), do:
      """
      *Dish*: #{name}
      *Description*: #{details}
      """
  end
end
