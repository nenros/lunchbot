defmodule Lunchbot.Lunchroom.Lunch.HTMLParserTest do
  use ExUnit.Case

  alias Lunchbot.Lunchroom.Lunch.HTMLParser

  @moduletag :capture_log

  doctest Lunchbot.Lunchroom.Lunch.HTMLParser

  describe "one selected dish" do
    test "it parse file correctly" do
      {:ok, html} = File.read("#{File.cwd!}/test/fixtures/one_selected_dish.txt")
      assert {
               :ok,
               [
                 %{
                   company: "Salad Story",
                   company_image: "https://airhelp.lunchroom.pl/public/img/company_logos/saladstory.jpeg",
                   details: "mix sałat, pomidory cherry, mix oliwek, fasolka szparagowa, pieczone ziemniaczki , tuńczyk, jajko. Dressing: vinegrette",
                   image: "https://airhelp.lunchroom.pl/public/photos/e19b4b11-c005-44a6-9e64-1fa0caf9dd6f.jpg",
                   name: "Sałatka nicejska"
                 }
               ]
             } == HTMLParser.parse(html)
    end
  end

  describe "two selected dishes" do
    test "it parse file correctly" do
      {:ok, html} = File.read("#{File.cwd!}/test/fixtures/two_selected_dishes.txt")
      assert {
               :ok,
               [
                 %{
                   company: "Rukola",
                   company_image: "https://airhelp.lunchroom.pl/public/img/company_logos/rukolacatering.png",
                   details: "kukurydza, imbir, cebula, czosnek, kurkuma, bulion warzywny, mleczko kokosowe, chili, słonecznik, oliwa, sól, pieprz",
                   image: "https://airhelp.lunchroom.pl/public/img/image-placeholder-food.png",
                   name: "Krem z kukurydzy z mleczkiem kokosowym"
                 },
                 %{
                   company: "Rukola",
                   company_image: "https://airhelp.lunchroom.pl/public/img/company_logos/rukolacatering.png",
                   details: "pierś kurczaka, ziemniaki, śmietana, kurki, kurkuma, pietruszka, cebula, koperek, sól, pieprz, miks sałat, ogórek, pomidor koktajlowy, papryka, pestki dyni, oliwa",
                   image: "https://airhelp.lunchroom.pl/public/photos/919b0272-91f8-4ad6-ab3f-4317dd6a0ff4.jpg",
                   name: "Filet z kurczaka na sosie kurkowym z młodymi ziemniakami i lekką sałatką"
                 }
               ]
             } == HTMLParser.parse(html)
    end
  end

  describe "many dishes to choose" do
    test "it parse file correctly" do
      {:ok, html} = File.read("#{File.cwd!}/test/fixtures/many_dishes.txt")
      assert { :ok, dishes } = HTMLParser.parse(html)
      assert length(dishes) == 17
    end
  end
end
