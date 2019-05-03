class Post < ApplicationRecord
  has_secure_password validations: false

  belongs_to :topic
  has_many :active_relationships,
           foreign_key: "follower_id", class_name: "PostRelationship",
           dependent: :destroy
  has_many :passive_relationships,
           foreign_key: "followed_id", class_name: "PostRelationship",
           dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  default_scope -> { order(id: :asc) }

  mount_uploaders :images, ImageUploader
  before_destroy :clean_s3
  # serialize :images, JSON
  # serialize :image_descriptions, JSON

  validates :body, presence: true, length: { maximum: 1000 }
  validate :images_length, :images_size

  LIMIT_SIZE = 2.freeze

  # Post関係(フォロー、アンフォロー)
  def follow(other_post)
    if other_post.present?
      if other_post.class == Post && other_post.valid? && (!following?(other_post))
        following << other_post
      elsif other_post.class == Fixnum && other_post != 0
        other_poster = Post.find_by(id: other_post)
        if other_poster.present? && (!following?(other_poster))
          following << other_poster
        end
      end
    end
  end

  def unfollow(other_post)
    active_relationships.find_by(followed_id: other_post.id).destroy
  end

  def following?(other_post)
    following.include?(other_post)
  end

  private
    # ransack:画像内文字検索のためのキャスト
    ransacker :image_descriptions do
      Arel::Nodes::SqlLiteral.new "regexp_replace(image_descriptions::varchar, \'\\r|\\n|\\r\\n\', \'\')"
    end
    def images_length
      if images.length > 3
        errors.add(:images, "の枚数は3枚までです。")
      end
    end

    def images_size
      images.each_with_index do |image, index|
        if image.size > LIMIT_SIZE.megabytes
          errors.add(:images, "の#{index + 1}枚目が#{LIMIT_SIZE}MBを超過しています。")
        end
      end
    end

    def clean_s3
      if images.present?
        #images.each do |image|
          # eachしないでokっぽい
          images[0].remove!       #オリジナルの画像を削除
          images[0].thumb.remove! #thumb画像を削除
        #end
      end
    rescue Excon::Errors::Error => error
      puts "Something gone wrong"
      false
    end
end
