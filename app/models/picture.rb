class Picture < ApplicationRecord
  has_one_attached :image

  validates :title, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 500 }

  validate :image_type, :image_size, :image_present

  private

  def image_present
    errors.add(:image, I18n.t("activerecord.errors.models.picture.attributes.image.required")) if image.blank?
  end

  private

  def image_type
    if image.attached? && !image.blob.content_type.start_with?("image/")
      image.purge
      errors.add(:image, I18n.t("activerecord.errors.models.picture.attributes.image.required"))
    end
  end

  def image_size
    if image.attached? && image.blob.byte_size > 3.megabytes
      image.purge
      errors.add(:image, t("activerecord.errors.models.picture.attributes.title.blank"))
    end
  end
end
