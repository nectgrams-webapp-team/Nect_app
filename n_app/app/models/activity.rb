class Activity < ApplicationRecord
  belongs_to :member
  has_one_attached :activity_image

  validates :title, presence: true
  validates :body, presence: true

  def get_activity_image
    (activity_image.attached?) ? activity_image : 'no_image.png'
  end
end
