#require "digest/sha2"
class User < ActiveRecord::Base
  #include Authentication
  #include Authentication::ByPassword
  #include Authentication::ByCookieToken

  has_one :field

  validates_format_of :name, :with => Authentication.name_regex, :message => Authentication.bad_name_message,
    :allow_nil => true
  validates_length_of :name, :maximum => 100

  validates_presence_of :email
  validates_length_of :email, :within => 6..100
  validates_uniqueness_of :email
  validates_format_of :email, :with => Authentication.email_regex, :message => Authentication.bad_email_message

  attr_accessible :login, :email, :name, :password

  def has_password?(submitted_password)
    password == submitted_password
  end

=begin
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_by_email(login.downcase)
    u && u.authenticated?(password) ? u : nil
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
=end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end

   def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
end
