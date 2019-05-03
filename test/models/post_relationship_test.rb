require 'test_helper'

class PostRelationshipTest < ActiveSupport::TestCase
  def setup
    @post_relationship = PostRelationship.new(follower_id: posts(:love).id, followed_id: posts(:hate).id)
  end

  test "モデルが有効" do
    assert @post_relationship.valid?
  end

  test "フォロワーが必須" do
    @post_relationship.follower_id = nil
    assert_not @post_relationship.valid?
  end

  test "フォロードが必須" do
    @post_relationship.followed_id = nil
    assert_not @post_relationship.valid?
  end
end
