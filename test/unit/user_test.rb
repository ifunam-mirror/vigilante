require 'test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users

  should_not_allow_values_for :login, 'al', :message => /too short/
  should_not_allow_values_for :login, 's' * 31, :message => /too long/
  should_not_allow_values_for :login, '@@@', :message => /is invalid/

  should_not_allow_values_for :email, "a@s.c", :message => /too short/
  should_not_allow_values_for :email, 'user@'+'domain' * 16 + '.com', :message => /too long/
  should_not_allow_values_for :email, 'user@d@main.com', :message => /is invalid/
  should_not_allow_values_for :email, 'user.domain.com', :message => /is invalid/

  def test_encrypt
    assert_equal '63f6fe797026d794e0dc3e2bd279aee19dd2f8db67488172a644bb68792a570c', User.encrypt('somestring')
  end
  
  def test_authenticate?
    # Password: string + salt 
    # 0191d608052c71f80e80f0cf5178b4c8eed78e7e249219f487ce15c0f2520ab3
    # Salt based on this date: "Sat Aug 30 08:38:15 -0500 2008"
    # 6edcc3797db
    assert User.authenticate?('admin', 'qw12..')
    assert User.authenticate?('john', 'qw12..')
  end
  
  def test_should_create_user
    assert_difference 'User.count' do
      record = User.build_valid!
      deny record.new_record?, "#{record.errors.full_messages.to_sentence}"
      record.activate
      assert User.authenticate?(User.build_valid[:login], User.build_valid[:password])
    end
  end
  
  def test_should_activate_user
    record = User.build_valid!
    assert !record.is_activated?
    assert record.activate
    assert record.is_activated?
  end
  
  def test_should_unactivate_user
    record = User.find_by_login('john')
    assert record.unactivate
    assert !record.is_activated?
  end
end
