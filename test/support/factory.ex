defmodule Lunchbot.Factory do
  use ExMachina
  @dish_name [
    "Box hummus falafel",
    "Box kurczak chilli",
    "Sałatka wege miska",
    "Sałatka neapolitana",
    "Mango kurczak",
    "Krem z marchwi i batata",
    "Warzywa wok z sosem teryaki",
  ]

  @dish_ingredients [
    "pilaw z ryżu, falafel jaglany, pomidorki cherry, surówka z czerwonej kapusty, ser typu greckiego. Dressing: Carrot Miso",
    "kasza pęczak, kurczak chilli, rucola, kiełki słonecznika, surówka z czerwonej kapusty, fasolki edemame, papryka, mix pestek (dynia i słonecznik) Dressing: Orientalne Chilli",
    "szpinak, jarmuż, falafel jaglany, papryka, ciecierzyca, pomidory suszone, mix pestek (dynia i słonecznik), burak pieczony, tofu. Dressing: green goodes",
    "mix sałat, pomidory cherry, rucola, pomidory suszone, mozzarella, makaron, kurczak w ziołach, mix oliwek. Dressing : green goddes",
    "mix sałat, mango, marchew, kasza pęczak z kurkumą, kapusta czerwona, papryka, kurczak chilli. Dresiing: fistaszkowy",
    "wywar warzywny, cebula, ziemniaki, marchew, bataty, mleko kokosowe, przyprawy",
  ]

  def html_dishes_factory do
    %{
      company: "Airhelp",
      company_image: "https://airhelp.lunchroom.pl/public/img/company_logos/airhelp.png",
      name: sequence(:dish_name, @dish_name),
      details: sequence(:dish_name, @dish_ingredients),
    }
  end

  def lunch_factory do
    %Lunchbot.Lunchroom.Lunch{
      company: "Airhelp",
      company_image: "https://airhelp.lunchroom.pl/public/img/company_logos/airhelp.png",
      dishes: []
    }
  end

  def dish_factory do
    %Lunchbot.Lunchroom.Lunch.Dish{
      name: sequence(:dish_name, @dish_name),
      details: sequence(:dish_name, @dish_ingredients),
      image: "http://image"
    }
  end



end
