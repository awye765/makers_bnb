require 'bcrypt'

class User
  include DataMapper::Resource

  attr_accessor :password_confirmation

  property :id, Serial
  property :first_name, String, required: true
  property :last_name, String, required: true
  property :email, String, format: :email_address, required: true, unique: true
  property :password_hash, Text, required: true

  validates_confirmation_of :password

  def password=(password)
    @password = password
    self.password_hash = BCrypt::Password.create(password)
  end
end