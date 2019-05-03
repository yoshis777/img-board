class Topic < ApplicationRecord
  has_many :posts, dependent: :destroy
  accepts_nested_attributes_for :posts
  default_scope -> { order(created_at: :desc) }
  validates :title, presence: true, length: { maximum: 50 }

end
