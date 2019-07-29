defmodule WebhookServer.HTMLParserTest do
  use ExUnit.Case

  alias WebhookServer.HTMLParser

  @moduletag :capture_log

  @example_response """
  "<div class=\"box\"><h2 class=\"menu-open\"><i class=\"fa fa-check-circle \"></i><i class=\"fa fa-check-circle gray\">
  </i>Monday, 22/07 <span class=\"status hidden-sm hidden-xs\"> You <strong>can&apos;t change</strong> your lunches for
  this day. Deadline was on Thursday, 18/07 at 19:00 </span></h2><div class=\"row menu menu-open\"><div class=\"col-md-12\">
  <!--  <textarea style=\"width:100%; height:500px;\">--><!--</textarea>--><div class=\"row\"><div data-id-menu=\"773\"
  data-id-vendor=\"4\" class=\"col-md-3 one-day  selected not-selectable\" style=\"clear:both;\"><div class=\"one-day-box\">
  <div class=\"check\"><i class=\"fa fa-check-circle\"></i></div><div class=\"hover show-more-info\"><div class=\"show-more\">
  <span>Show more details</span></div><div class=\"content opacity\"><div class=\"company\"><span class=\"logo\">
  <img src=\"/public/img/company_logos/saladstory.jpeg\" width=\"25\"/></span><span class=\"brand\"> Salad Story</span>
  </div><!-- #--><div class=\"name\">Sałatka avocado rybak</div><div class=\"description\">
  <strong>Description</strong>:-</div><div class=\"details\"><strong>Ingredients</strong>:mix sałat, łosoś, awokado, mix
  fasolek, suszone pomidory, kiełki słonecznika, pilaw z ryzu. Dressing: Francuski</div><div class=\"tags\"><span
  class=\"label show-tooltip short\" style=\"cursor:pointer; background: #FFAD76;\" data-toggle=\"tooltip\"
  data-container=\"body\" data-original-title=\"Soja\">S</span><span class=\"label show-tooltip full\"
  style=\"cursor:pointer; background: #FFAD76;\" data-toggle=\"tooltip\" data-container=\"body\" data-original-title=\"Soja\">
  Soja</span><span class=\"label show-tooltip short\" style=\"cursor:pointer; background: #D1B300;\" data-toggle=\"tooltip\"
  data-container=\"body\" data-original-title=\"Orzechy\">O</span><span class=\"label show-tooltip full\"
  style=\"cursor:pointer; background: #D1B300;\" data-toggle=\"tooltip\" data-container=\"body\"
  data-original-title=\"Orzechy\">Orzechy</span></div></div><div class=\"img opacity\"
  style=\"background-image: url(/public/photos/dee23373-b2d4-4f94-a50b-3f21a311c8fb.png);\">
  <img src=\"/public/photos/dee23373-b2d4-4f94-a50b-3f21a311c8fb.png\"/></div></div><div class=\"action-buttons opacity\">
  <button class=\"btn btn-outline-success\">Ordered</button><a href=\"http://www.google.com/calendar/event?action=
  TEMPLATE&text=Lunchroom%3A+Salad+Story&dates=20190722T100000Z/20190722T100000Z&details=Sa%C5%82atka+avocado+rybak&location=Air+Help\"
  class=\"btn btn-danger show-tooltip\" target=\"_blank\" data-toggle=\"tooltip\" data-container=\"body\"
  data-original-title=\"Add to Google Calendar\"><i class=\"fa fa-calendar\"></i></a></div></div></div></div></div></div></div>"
  """

  doctest HTMLParser

  test "should parse html to mapt" do
    HTMLParser.parse_food(@example_response)
    |> IO.inspect
  end
end
