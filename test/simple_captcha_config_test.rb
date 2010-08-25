
require File.join(File.dirname(__FILE__), 'test_helper')

require 'simple_captcha_config'

class SimpleCaptchaConfigTest < ActiveSupport::TestCase

  test 'backend configuration defaults to RMagick' do
    assert_not_nil SimpleCaptcha.backend
    assert_equal 'SimpleCaptcha::RMagickBackend', SimpleCaptcha.backend.to_s
  end

  test 'set backend configuration to quick_magick' do
    SimpleCaptcha.backend = :quick_magick
    
    assert_not_nil SimpleCaptcha.backend
    assert_equal 'SimpleCaptcha::QuickMagickBackend', SimpleCaptcha.backend.to_s
  end

  test 'set backend configuration to RMagick' do
    SimpleCaptcha.backend = :RMagick

    assert_not_nil SimpleCaptcha.backend
    assert_equal 'SimpleCaptcha::RMagickBackend', SimpleCaptcha.backend.to_s
  end

  test 'set backend configuration to rmagick' do
    SimpleCaptcha.backend = :rmagick

    assert_not_nil SimpleCaptcha.backend
    assert_equal 'SimpleCaptcha::RMagickBackend', SimpleCaptcha.backend.to_s
  end

end