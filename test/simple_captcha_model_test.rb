
require File.join(File.dirname(__FILE__), 'test_helper')

ActiveRecord::Migration.verbose = false # quiet down the migration engine
ActiveRecord::Base.configurations = { 'test' => {
  'adapter' => 'sqlite3', 'database' => ':memory:'
}}
ActiveRecord::Base.establish_connection('test')
ActiveRecord::Base.silence do
  ActiveRecord::Schema.define(:version => 0) do
    create_table :users, :force => true do |t|
      t.string  :type
      t.string  :name
    end
    create_table :simple_captcha_data do |t|
      t.string :key
      t.string :value
      t.timestamps
    end
  end
end

class SimpleCaptchaModelTest < ActiveSupport::TestCase

  CAPTCHA_DISABLED = false

  class UserWithCaptcha < ActiveRecord::Base
    set_table_name 'users'

    validates_captcha :unless => lambda { SimpleCaptchaModelTest::CAPTCHA_DISABLED }
  end

  class InheritedUser < UserWithCaptcha
  end

  test 'captcha validations run by default' do
    user = UserWithCaptcha.new
    assert ! user.valid?
  end

  test 'captcha validations is skipped when condition is met' do
    user = UserWithCaptcha.new
    assert ! user.valid?
    begin
      SimpleCaptchaModelTest.const_set(:CAPTCHA_DISABLED, true)
      assert user.valid?
      assert UserWithCaptcha.new.valid?
    ensure
      SimpleCaptchaModelTest.const_set(:CAPTCHA_DISABLED, false)
    end
  end

#  test 'captcha validations might be disabled for class' do
#    user = UserWithCaptcha.new
#    begin
#      UserWithCaptcha.disable_captcha_validation
#      assert user.valid?
#      assert UserWithCaptcha.new.valid?
#    ensure
#      UserWithCaptcha.enable_captcha_validation
#    end
#  end
#
#  test 'captcha validations might be disabled for block' do
#    user = UserWithCaptcha.new
#    UserWithCaptcha.disable_captcha_validation do
#      assert user.valid?
#      assert UserWithCaptcha.new.valid?
#    end
#  end
#
#  test 'disabling validations is not inherited' do
#    UserWithCaptcha.disable_captcha_validation do
#      assert UserWithCaptcha.new.valid?
#      assert ! InheritedUser.new.valid?
#    end
#  end
#
#  test 'disabled captcha validations get enabled for block' do
#    user = UserWithCaptcha.new
#    begin
#      assert ! user.valid?
#      UserWithCaptcha.disable_captcha_validation
#      assert user.valid?
#      UserWithCaptcha.enable_captcha_validation do
#        assert ! user.valid?
#        assert ! UserWithCaptcha.new.valid?
#      end
#      assert user.valid?
#      assert UserWithCaptcha.new.valid?
#    ensure
#      UserWithCaptcha.enable_captcha_validation
#    end
#  end

  test 'captcha validation outcome is kept on multiple calls 1' do
    SimpleCaptchaData.create! :key => '1234567890', :value => 'ABCDEF'

    user = UserWithCaptcha.new :name => 'U1', :captcha => 'XYZ', :captcha_key => '1234567890'
    assert ! user.valid?
    user.name = 'U2'
    assert ! user.valid?
    assert ! user.valid?
    assert ! user.save
    assert ! user.valid?
  end

  test 'captcha validation outcome is kept on multiple calls 2' do
    SimpleCaptchaData.create! :key => '1234567890', :value => 'ABCDEF'

    user = UserWithCaptcha.new :name => 'U1', :captcha => 'ABCDEF', :captcha_key => '1234567890'
    assert user.valid?
    user.name = 'U2'
    assert user.valid?
    assert user.valid?
    assert user.save
    assert user.valid?
  end

end