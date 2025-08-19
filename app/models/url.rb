class Url < ApplicationRecord
  MAXIMUM_ORIGINAL_LENGTH = 1024
  MAXIMUM_SHORT_CODE_LENGTH = 11

  with_options presence: true do |u|
    u.validates :original_url, length: { maximum: MAXIMUM_ORIGINAL_LENGTH }
    u.validates :short_code, length: { maximum: MAXIMUM_SHORT_CODE_LENGTH }, uniqueness: true
  end
end
