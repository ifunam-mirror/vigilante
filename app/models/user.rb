require 'digest/sha2'
class User < ActiveRecord::Base
  attr_accessor :current_password

  validates_presence_of       :login, :email, :password
  validates_length_of         :login, :within => 3..30
  validates_length_of         :email, :within => 7..100
  validates_length_of         :password, :within => 5..200, :allow_nil => true
  validates_confirmation_of   :password
  validates_inclusion_of      :status, :is_admin, :in => [true, false]
  validates_format_of         :login, :with =>  /\A[-a-z0-9\.\-\_]*\Z/
  validates_format_of         :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/
  validates_uniqueness_of     :login
  validates_uniqueness_of     :email
  validates_uniqueness_of     :login, :scope => [:email]

  
  before_create :prepare_new_record

  def self.authenticate?(login,pw)
    record = User.find_by_login(login)
    !record.nil? and !record.salt.nil? and record.password == User.encrypt(pw + record.salt) and record.is_activated? ? true : false
  end
  
  def self.encrypt(string)
    Digest::SHA2.hexdigest(string)
  end

  def activate
    change_status(true)
  end
  
  def unactivate
    change_status(false)
  end
  
  def is_activated?
    self.status == true
  end

  private
  def prepare_new_record
    self.status = false
    self.salt = salt_generator
    self.password = User.encrypt(password + self.salt)
    self.password_confirmation = nil
  end

  def salt_generator
    User.encrypt(Time.now.to_s).slice(0..10)
  end

  def change_status(status)
    self.status = status
    save(true)
  end
end
