class Micropost < ApplicationRecord
  belongs_to :user

  has_one_attached :image

  validates :user_id, presence: true
  validates :content, presence: true, length:
            {maximum: Settings.valid.maxlength_content}
  validates :image, content_type:
            {in: Settings.micropost.image_type, message: :wrong_format},
            size:
            {less_than: Settings.micropost.image_size.megabytes,
             message: :too_big}

  delegate :name, to: :user, prefix: true

  scope :newest, ->{order(created_at: :desc)}

  def display_image
    image.variant resize_to_limit: Settings.micropost.resize_to_limit
  end
end
