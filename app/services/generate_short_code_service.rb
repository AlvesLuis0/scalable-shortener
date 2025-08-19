# frozen_string_literal: true

class GenerateShortCodeService
  def initialize(id)
    @id = id
  end

  def call
    base62_part = encode_base62(@id)
    hash_part = Digest::SHA1.hexdigest("#{@id}#{SALT}")[0..3]
    "#{base62_part}#{hash_part}"
  end

  private

  ALPHABET = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".chars.freeze
  BASE = ALPHABET.size
  SALT = ENV.fetch("SHORT_CODE_SALT", Rails.application.credentials.short_code_salt)

  def encode_base62(num)
    return ALPHABET[0] if num == 0

    chars = []
    while num > 0
      chars << ALPHABET[num % BASE]
      num /= BASE
    end
    chars.reverse.join
  end
end
