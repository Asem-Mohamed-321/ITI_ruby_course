class Article < ApplicationRecord
  belongs_to :user

  
  mount_uploader :image, ImageUploader

  before_save :check_reports_count

  private

  def check_reports_count
    if reports_count.present? && reports_count >= 3
      self.archived = true
    end
  end
end
