class Url < ApplicationRecord
  include Rails.application.routes.url_helpers

  MAXIMUM_ORIGINAL_LENGTH = 1024
  MAXIMUM_SHORT_CODE_LENGTH = 11

  with_options presence: true do |u|
    u.validates :original_url, length: { maximum: MAXIMUM_ORIGINAL_LENGTH }
    u.validates :short_code, length: { maximum: MAXIMUM_SHORT_CODE_LENGTH }, uniqueness: true
  end

  def shorted_url
    short_redirect_url(short_code: short_code)
  end
end
