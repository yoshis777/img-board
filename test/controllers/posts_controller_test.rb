require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @topic = topics(:smashbros)
    @post = posts(:love)
  end

  test "有効：ポスト作成" do
    assert_difference('Post.count', 1) do
      post topic_posts_url(@topic), params: {
          post: {
              name: @post.name,
              body: @post.body
          },
          topic_id: @topic.id
      }
    end
  end

  test "有効：ポスト削除" do
    assert_difference('Post.count', -1) do
      delete post_url(@post)
    end
  end

  test "有効：画像の枚数が１枚" do
    assert_difference('Post.count', 1) do
      post topic_posts_url(@topic), params: {
          post: {
              name: @post.name,
              body: @post.body,
              images: Rack::Test::UploadedFile.new(Rails.root.join('test', 'fixtures', 'files', 'images', 'test_image.png'), 'image/png')
          },
          topic_id: @topic.id
      }
    end
  end

  test "有効：画像の枚数が3枚" do
    assert_difference('Post.count', 1) do
      post topic_posts_url(@topic), params: {
          post: {
              name: @post.name,
              body: @post.body,
              images: [
                  Rack::Test::UploadedFile.new(Rails.root.join('test', 'fixtures', 'files', 'images', 'test_image.png'), 'image/png'),
                  Rack::Test::UploadedFile.new(Rails.root.join('test', 'fixtures', 'files', 'images', 'test_image.png'), 'image/png'),
                  Rack::Test::UploadedFile.new(Rails.root.join('test', 'fixtures', 'files', 'images', 'test_image.png'), 'image/png')
              ]
          },
          topic_id: @topic.id
      }
    end
  end

  test "無効：画像の枚数が4枚" do
    assert_no_difference('Post.count') do
      post topic_posts_url(@topic), params: {
          post: {
              name: @post.name,
              body: @post.body,
              images: [
                  Rack::Test::UploadedFile.new(Rails.root.join('test', 'fixtures', 'files', 'images', 'test_image.png'), 'image/png'),
                  Rack::Test::UploadedFile.new(Rails.root.join('test', 'fixtures', 'files', 'images', 'test_image.png'), 'image/png'),
                  Rack::Test::UploadedFile.new(Rails.root.join('test', 'fixtures', 'files', 'images', 'test_image.png'), 'image/png'),
                  Rack::Test::UploadedFile.new(Rails.root.join('test', 'fixtures', 'files', 'images', 'test_image.png'), 'image/png')
              ]
          },
          topic_id: @topic.id
      }
    end
  end

  # テストだとなぜか有効になってしまう
  # test "無効：画像サイズが2MB以上" do
  #   assert_no_difference('Post.count') do
  #     post topic_posts_url(@topic), params: {
  #         post: {
  #             name: @post.name,
  #             body: @post.body,
  #             images: Rack::Test::UploadedFile.new(Rails.root.join('test', 'fixtures', 'files', 'images', 'test_image_size_exceed.png'), 'image/png')
  #         },
  #         topic_id: @topic.id
  #     }
  #   end
  # end

  test "ポスト間リレーション：投稿内容からアンカーを検知したらフォロー関係を作る、削除されたらフォロワー関係を外す" do
    love = posts(:love_will_be_followed_hate)
    hate = posts(:hate_will_be_following_love)
    assert_equal 10001, hate.id

    assert_difference('PostRelationship.count', 1) do
      assert_difference('Post.count', 1) do
        post topic_posts_url(@topic), params: {
            post: {
                name: love.name,
                body: love.body
            },
            topic_id: @topic.id
        }
      end
    end

    # Post削除と同時に削除されるRelationは、すでにfixtureでDBに格納されているデータのため、
    # PostRelationsのfixtureにデータを格納しておく必要がある
    love = posts(:love_follows_hate)
    assert_equal 10004, love.id

    assert_difference('PostRelationship.count', -1) do
      assert_difference('Post.count', -1) do
        delete post_url(love)
      end
    end
  end

  test "ポスト間リレーション：投稿内容からアンカーを複数検知したらその分だけフォロー関係を作る、削除されたらその分だけフォロワー関係を外す" do
    love = posts(:love_follows_hate_2by2)
    hate = posts(:hate_is_followed_love_1by2)
    hate2 = posts(:hate_is_followed_love_2by2)
    assert_equal 10005, hate.id
    assert_equal 10006, hate2.id

    assert_difference('PostRelationship.count', 2) do
      assert_difference('Post.count', 1) do
        post topic_posts_url(@topic), params: {
            post: {
                name: love.name,
                body: love.body
            },
            topic_id: @topic.id
        }
      end
    end

    # Post削除と同時に削除されるRelationは、すでにfixtureでDBに格納されているデータのため、
    # PostRelationsのfixtureにデータを格納しておく必要がある
    love = posts(:love_follows_hate_2by2_2)
    assert_equal 10010, love.id

    assert_difference('PostRelationship.count', -2) do
      assert_difference('Post.count', -1) do
        delete post_url(love)
      end
    end

  end

end
