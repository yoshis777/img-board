class PostRelationship < ApplicationRecord
  belongs_to :follower, class_name: "Post"
  belongs_to :followed, class_name: "Post"
  validates :follower_id, presence: true, uniqueness: {scope: :followed_id}
  validates :followed_id, presence: true, uniqueness: {scope: :follower_id}
end
