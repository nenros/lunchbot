defmodule Lunchbot.WebhookTest do
  use Lunchbot.RepoCase, async: true

  alias Lunchbot.Webhook

  @moduletag :capture_log

  doctest Webhook

#  describe "#get_slack_data" do
#    @slack_query "token=test_tokeng&team_id=AIRLP1&team_domain=lunchbotairhelp&channel_id=CCHANNEL&channel_name=general&user_id=USERID&user_name=nenros&command=%2Flunch&text=today&response_url=https%3A%2F%2Fhooks.slack.com%2Fcommands%2FTL35W%2F7099%2FDzeXQVwQ5sfPo&trigger_id=70309.6971225.4ebd3cacd146f4e411b"
#
#    test "put correct data in webhook" do
#      expected = %Webhook{
#        slack_data: %{
#          text: "today",
#          user_id: "USERID",
#          user_name: "nenros"
#        }
#      }
#
#      assert {:ok, expected} == Lunchbot.Webhook.get_slack_data(%Webhook{}, @slack_query)
#    end
#  end
#
#  describe "#set_action_to_perform" do
#    @actions [
#      {"today", Webhook.Lunch, []},
#      {"magiclink https://magiclink/test", Webhook.Magiclink, ["https://magiclink/test"]}
#    ]
#
#    ExUnit.Case.register_attribute(__ENV__, :action)
#
#    Enum.each(
#      @actions,
#      fn {command, module, param} ->
#        @action {command, module, param}
#
#        test "for command #{command} set module #{module}",
#             %{
#               registered: %{
#                 action: action
#               }
#             } do
#          {command, module, param} = action
#
#          given = %Webhook{
#            slack_data: %{
#              text: command
#            }
#          }
#
#          expected =
#            given
#            |> Map.put(:module, module)
#            |> Map.put(:params, param)
#
#          assert {:ok, expected} == Lunchbot.Webhook.set_action_to_perform(given)
#        end
#      end
#    )
#
#    test "ensure actions exists" do
#      Webhook.get_possible_actions_with_modules()
#      |> Map.values()
#      |> Enum.each(fn module -> assert is_list(module.module_info()) end)
#    end
#
#    test "return :error for unknown command" do
#      given = %Webhook{
#        slack_data: %{
#          text: "unknown"
#        }
#      }
#
#      assert {:error, :command_unknow} == Lunchbot.Webhook.set_action_to_perform(given)
#    end
#  end
#
#  describe "#set_user_if_exists" do
#    test "assign user if exists" do
#      slack_data = %{user_id: "UL5MEDGN7", user_name: "nenros"}
#      {:ok, user} = Lunchbot.Repo.Users.create_user(slack_data)
#
#      given = %Webhook{
#        slack_data: slack_data
#      }
#
#      expected = %Webhook{
#        user: user,
#        slack_data: slack_data
#      }
#
#      assert Webhook.set_user_if_exists(given) == {:ok, expected}
#    end
#
#    test "return webhook without user" do
#      slack_data = %{user_id: "UL5MEDGN7", user_name: "nenros"}
#
#      given = %Webhook{
#        slack_data: slack_data
#      }
#
#      assert Webhook.set_user_if_exists(given) == {:ok, given}
#    end
#  end
#
#  describe "#perform_action" do
#    body = %{text: "test"}
#
#    given = %Webhook{
#      module: Webhook.Test,
#      params: [body]
#    }
#
#    expected =
#      Map.put(given, :response, %{
#        status_code: 200,
#        type: "application/json",
#        body: body
#      })
#
#    assert Webhook.perform_action(given) == {:ok, expected}
#  end
end
