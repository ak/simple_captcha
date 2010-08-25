
require 'quick_magick'

module SimpleCaptcha

  module QuickMagickBackend

    def self.generate_simple_captcha_image(options={})
      image = QuickMagick::Image::solid(110, 30, :white)
      image.format = 'JPG'

      image_options = SimpleCaptcha::ImageHelpers.image_options(options)
      set_simple_captcha_image_style(image, image_options)
      image.implode(0.2).to_blob
    end

    private

    def self.set_simple_captcha_image_style(image, image_options)
      amplitude, frequency = image_options[:distortion]
      case image_options[:image_style]
      when 'embosed_silver'
        append_simple_captcha_code(image, image_options)
        image = image.wave(amplitude, frequency).shade('20x60')
      when 'simply_red'
        image_options[:color] = 'darkred'
        append_simple_captcha_code(image, image_options)
        image = image.wave(amplitude, frequency)
      when 'simply_green'
        image_options[:color] = 'darkgreen'
        append_simple_captcha_code(image, image_options)
        image = image.wave(amplitude, frequency)
      when 'simply_blue'
        append_simple_captcha_code(image, image_options)
        image = image.wave(amplitude, frequency)
      when 'distorted_black'
        append_simple_captcha_code(image, image_options)
        image = image.wave(amplitude, frequency).edge(10)
      when 'all_black'
        append_simple_captcha_code(image, image_options)
        image = image.wave(amplitude, frequency).edge(2)
      when 'charcoal_grey'
        append_simple_captcha_code(image, image_options)
        image = image.wave(amplitude, frequency).charcoal(0)
      when 'almost_invisible'
        image_options[:color] = 'red'
        append_simple_captcha_code(image, image_options)
        image = image.wave(amplitude, frequency).solarize(50)
      else
        append_simple_captcha_code(image, image_options)
        image = image.wave(amplitude, frequency)
      end
    end

    def self.append_simple_captcha_code(image, image_options)
      image.family = 'arial'
      image.pointsize = 22
      image.fill = image_options[:color]
      image.gravity = 'center'
      image.draw_text 0, 5, image_options[:captcha_text]
    end

  end

end
