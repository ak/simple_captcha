# Copyright (c) 2008 [Sur http://expressica.com]

require 'digest/sha1'

module SimpleCaptcha #:nodoc

  @@image_path = "#{RAILS_ROOT}/vendor/plugins/simple_captcha/assets/images/simple_captcha/"
  def self.image_path
    @@image_path
  end

  def self.image_path=(image_path)
    @@image_path = image_path
  end

  @@backend = nil
  def self.backend
    self.backend = :RMagick unless @@backend
    @@backend
  end

  def self.backend=(backend)
    if backend.is_a?(Symbol) || backend.is_a?(String)
      backend = backend.to_s.camelize
      backend_const = const_get(backend + 'Backend') rescue nil
      backend_const = const_get(backend) rescue nil unless backend_const
      raise "unsupported backend: #{backend}" unless backend_const
      backend = backend_const
    end
    unless backend.respond_to?(:generate_simple_captcha_image)
      raise "invalid backend: #{backend} - does not respond to :generate_simple_captcha_image"
    end
    @@backend = backend
  end

  module ConfigTasks #:nodoc

    private
    
      def simple_captcha_image_path #:nodoc
        SimpleCaptcha.image_path
      end

      def simple_captcha_key #:nodoc
        session[:simple_captcha] ||= Digest::SHA1.hexdigest(Time.now.to_s + session.session_id.to_s)
      end

      def simple_captcha_value(key = simple_captcha_key) #:nodoc
        SimpleCaptchaData.get_data(key).value rescue nil
      end

      def simple_captcha_passed!(key = simple_captcha_key) #:nodoc
        SimpleCaptchaData.remove_data(key)
      end

  end

end
