require "argon2id"

# Schema: User(name: string, password_digest:string)
class User < ApplicationRecord
  attr_reader :password
  has_many :secrets

  validates :username, uniqueness: true
  validates :password_digest, presence: true

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
end
