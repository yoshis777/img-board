module TopicsHelper
  IMAGE_SIZE = 80
  NO_IMAGE_URL = "no_image.jpg"

  def get_last_post_image(topic)
    if topic.posts.present?
      last_image_post = topic.posts.find {|post| post.images.present? && post.images[0].thumb.present?}
      image_tag(last_image_post.present? ? last_image_post.images[0].thumb.url : NO_IMAGE_URL, size: (IMAGE_SIZE).to_s + "x" + (IMAGE_SIZE).to_s)
    end
  end
end
