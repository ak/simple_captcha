
require 'simple_captcha/config_tasks'
require 'simple_captcha/image_helpers'
require 'simple_captcha/view_helpers'
require 'simple_captcha/controller_helpers'
require 'simple_captcha/model_helpers'

module SimpleCaptcha

  @@image_path = nil
  def self.image_path
    @@image_path ||= "#{RAILS_ROOT}/vendor/plugins/simple_captcha/assets/images/simple_captcha/"
  end

  def self.image_path=(image_path)
    @@image_path = image_path
  end

  @@image_options = {
      :image_color => 'white',
      :image_size => '110x30',
      :text_color => 'black',
      :text_font => 'arial',
      :text_size => 22
  }
  def self.image_options
    @@image_options
  end

  def self.image_options=(image_options)
    @@image_options.merge! image_options
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

end
