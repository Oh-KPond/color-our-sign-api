class DisplayedColor < ApplicationRecord
  validates :color, presence: true
  validates :color, format: { with: /\A\d{1,3},\s?\d{1,3},\s?\d{1,3}\z/,
                               message: "must be RGB format like '51, 51, 51'" }
end
