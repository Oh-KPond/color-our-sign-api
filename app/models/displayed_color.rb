class DisplayedColor < ApplicationRecord
  MAX_HISTORY = 100

  validates :color, presence: true
  validates :color, format: { with: /\A\d{1,3},\s?\d{1,3},\s?\d{1,3}\z/,
                               message: "must be RGB format like '51, 51, 51'" }

  after_create :prune_history

  private

  def prune_history
    keep_ids = DisplayedColor.order(created_at: :desc).limit(MAX_HISTORY).pluck(:id)
    DisplayedColor.where.not(id: keep_ids).delete_all
  end
end
