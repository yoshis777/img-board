require 'test_helper'

class TopicsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @topic = topics(:smashbros)
  end

  test "トピック一覧表示" do
    get topics_url
    assert_response :success
  end

  test "トピック内容表示" do
    get topic_url(@topic.id)
    assert_response :success
  end

  test "トピック作成" do
    assert_difference('Topic.count', 1) do
      post topics_url, params: {
          topic: {
              title: @topic.title,
              name: @topic.name
          }
      }
    end
  end

  test "トピック削除" do
    assert_difference('Topic.count', -1) do
      delete topic_url(@topic)
    end
  end

end
