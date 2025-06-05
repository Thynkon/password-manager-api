require "argon2id"


# Schema: User(name: string, password_digest:string)
class User < ApplicationRecord
  # Reference: https://docs.rs/argon2/latest/argon2/constant.RECOMMENDED_SALT_LEN.html
  SALT_LENGTH=16

  attr_reader :password
  has_many :secrets

  validates :username, uniqueness: true
  validates :password_digest, presence: true

  before_create :ensure_sym_key_salt

  def password=(unencrypted_password)
    if unencrypted_password.nil?
      @password = nil
      self.password_digest = nil
    elsif !unencrypted_password.empty?
      @password = unencrypted_password
      self.password_digest = Argon2id::Password.create(unencrypted_password)
    end
  end

  def authenticate(unencrypted_password)
    password_digest? && Argon2id::Password.new(password_digest).is_password?(unencrypted_password) && self
  end

  def password_salt
    Argon2id::Password.new(password_digest).salt if password_digest?
  end

  def ensure_sym_key_salt
    self.sym_key_salt ||= Base64.strict_encode64(SecureRandom.bytes(SALT_LENGTH))
  end
end
