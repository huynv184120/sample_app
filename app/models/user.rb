class User < ApplicationRecord
  before_save :downcase_email
  validates :name, presence: true, length: {maximum: Settings.valid.name.maxlength}
  validates :email, presence: true, length: {minimum: Settings.valid.email.minlength, maximum: Settings.valid.email.maxlength},
    format: {with: Settings.regex.VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.valid.password.minlength}, if: :password
  has_secure_password
  
  def downcase_email
    email.downcase!
  end
end
