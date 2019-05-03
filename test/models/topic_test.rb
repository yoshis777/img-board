require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  def setup
    @topic = Topic.new(title: "テストタイトル", name: "トピック投稿者")
  end

  test "トピック消したらポストも消える" do
    @topic.save
    @topic.posts.create!(
      name: "ポスト投稿者",
      body: "ポスト内容"
    )
    assert_difference 'Topic.count', -1 do
      assert_difference 'Post.count', -1 do
        @topic.destroy
      end
    end
  end
end
