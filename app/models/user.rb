class User < ApplicationRecord
  attr_accessor :remember_token

  before_save { self.email = email.downcase}
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email,  presence: true, length: { maximum: 255 },
                     format: { with: VALID_EMAIL_REGEX },
                     uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
  # Returns a digested hash from a string
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? 
           BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # creates a random token base 64 url safe
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in DB for persistent sessions
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Check if a user us auth by matchin token to digest
  def authenticated? (remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(:remember_digest) == remember_token
  end

  # Forgets a user
  def forget
    update_attribute(:remember_digest, nil)
  end

end
