defmodule Lunchbot.Lunchroom.Lunch.Dish do
  defstruct [:name, :details, :image]

  defimpl String.Chars, for: Lunchbot.Lunchroom.Lunch.Dish do
    def to_string(%{name: name, detail: details}),
        do: """
          *Dish*: #{name}
          *Description*: #{details}
        """
  end
end
