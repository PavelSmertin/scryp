class User < ApplicationRecord

  has_one :portfolio

  has_secure_password
  validates :email, presence: true, length: { maximum: 255 }, format: { with: /\A[^@\s]+@([^@.\s]+\.)+[^@.\s]+\z/ }, uniqueness: { case_sensitive: false }


  attr_accessor :remember_token, :reset_token
  before_save   :downcase_email
  before_create :create_activation_digest

  def generate_json_api_error
    json_error = {"errors": []}
    errors.messages.each do |err_type, messages|
      messages.each do |msg|
        json_error[:errors] << {"detail": "#{err_type} #{msg}", "source": {"pointer": "user/err_type"}}
      end
    end
    json_error
  end


  def create_reset_digest
    self.reset_token = generate_pin
    update_attribute(:reset_digest,  reset_token)
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

   def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    p token
    return false if digest.nil?
    return token == digest
  end

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  private

    def generate_pin
      (0...4).map { (rand(9)) }.join
    end

    def downcase_email
      self.email = email.downcase
    end

    def create_activation_digest
      self.activation_digest = User.digest(User.new_token)
    end

end
