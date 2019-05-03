require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @post = posts(:love)
  end

  test "有効：普通に有効な投稿" do
    assert @post.valid?
  end

  test "有効：名前がない投稿" do
    @post.name = " "
    assert @post.valid?
  end

  test "無効：内容がない投稿" do
    @post.body = " "
    assert_not @post.valid?
  end

  test "無効：内容が1001文字" do
    @post.body = "a" * 1001
    assert_not @post.valid?
  end

  test "無効：内容が1000文字" do
    @post.body = "a" * 1000
    assert @post.valid?
  end

  test "Post間のリレーション：フォローする、アンフォローする" do
    love = posts(:love)
    hate = posts(:hate)
    assert_not love.following?(hate)
    love.follow(hate)
    assert love.following?(hate)
    assert hate.followers.include?(love)
    love.unfollow(hate)
    assert_not love.following?(hate)
  end
end
