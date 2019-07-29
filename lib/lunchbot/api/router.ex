defmodule Lunchbot.API.Router do
  use Raxx.Router
  alias Lunchbot.API.Actions

  def stack(config) do
    Raxx.Stack.new(
      [
        # Add global middleware here.
      ],
      {__MODULE__, config}
    )
  end

  # Call GreetUser and in WWW dir AND call into lib
  section [{Raxx.Logger, Raxx.Logger.setup(level: :info)}], [
    {%{path: ["webhook"]}, Actions.Webhook},
    {%{path: []}, Actions.WelcomeMessage},
  ]

  section [{Raxx.Logger, Raxx.Logger.setup(level: :debug)}], [
    {_, Actions.NotFound}
  ]
end
