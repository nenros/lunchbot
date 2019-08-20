defmodule Lunchbot.Factory do
  use ExMachina.Ecto, repo: Lunchbot.Repo

  @dish_name [
    "Box hummus falafel",
    "Box kurczak chilli",
    "Sałatka wege miska",
    "Sałatka neapolitana",
    "Mango kurczak",
    "Krem z marchwi i batata",
    "Warzywa wok z sosem teryaki"
  ]

  @dish_ingredients [
    "pilaw z ryżu, falafel jaglany, pomidorki cherry, surówka z czerwonej kapusty, ser typu greckiego. Dressing: Carrot Miso",
    "kasza pęczak, kurczak chilli, rucola, kiełki słonecznika, surówka z czerwonej kapusty, fasolki edemame, papryka, mix pestek (dynia i słonecznik) Dressing: Orientalne Chilli",
    "szpinak, jarmuż, falafel jaglany, papryka, ciecierzyca, pomidory suszone, mix pestek (dynia i słonecznik), burak pieczony, tofu. Dressing: green goodes",
    "mix sałat, pomidory cherry, rucola, pomidory suszone, mozzarella, makaron, kurczak w ziołach, mix oliwek. Dressing : green goddes",
    "mix sałat, mango, marchew, kasza pęczak z kurkumą, kapusta czerwona, papryka, kurczak chilli. Dresiing: fistaszkowy",
    "wywar warzywny, cebula, ziemniaki, marchew, bataty, mleko kokosowe, przyprawy"
  ]

  def html_dishes_factory do
    %{
      company: "Airhelp",
      company_image: "https://airhelp.lunchroom.pl/public/img/company_logos/airhelp.png",
      name: sequence(:dish_name, @dish_name),
      details: sequence(:dish_name, @dish_ingredients)
    }
  end

  def slack_params_factory do
    %{
      channel_id: random_string(6),
      channel_name: "test-workspace",
      command: "/lunch",
      response_url: "#{Faker.Internet.url()}/commands/TEST667/123456789/#{Faker.String.base64()}",
      team_domain: "testlunchbot",
      team_id: random_string(6),
      text: "",
      token: "token12456789",
      trigger_id: "#{Faker.random_bytes(10)}.#{Faker.random_bytes(10)}.#{Faker.String.base64()}",
      user_id: random_string(6),
      user_name: Faker.Internet.user_name()
    }
  end

  def user_factory do
    %Lunchbot.Repo.Users.User{
      user_name: Faker.Internet.user_name(),
      user_id: random_string(6),
      magiclink: magiclink_factory(%{})
    }
  end

  def help_params_factory do
    %{slack_params_factory() | text: "help"}
  end

  def magiclink_factory(_attrs) do
    sequence(
      :magiclink,
      &"https://airhelp.lunchroom.pl/autoLogin/#{URI.encode(Faker.Internet.email())}/#{
        Faker.String.base64()
      }#{&1}"
    )
  end

  defp random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.encode64() |> binary_part(0, length)
  end
end
