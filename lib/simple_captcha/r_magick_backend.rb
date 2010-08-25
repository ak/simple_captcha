
require 'RMagick'

module SimpleCaptcha

  module RMagickBackend

    def self.generate_simple_captcha_image(options={})
      image = Magick::Image.new(110, 30) do
        self.background_color = 'white'
        self.format = 'JPG'
      end

      image_options = SimpleCaptcha::ImageHelpers.image_options(options)
      set_simple_captcha_image_style(image, image_options)
      image.implode(0.2).to_blob
    end

    private

    def self.append_simple_captcha_code(image, image_options)
      color = image_options[:color]
      text = Magick::Draw.new
      text.annotate(image, 0, 0, 0, 5, image_options[:captcha_text]) do
        self.font_family = 'arial'
        self.pointsize = 22
        self.fill = color
        self.gravity = Magick::CenterGravity
      end
    end

    def self.set_simple_captcha_image_style(image, image_options)
      amplitude, frequency = image_options[:distortion]
      case image_options[:image_style]
      when 'embosed_silver'
        append_simple_captcha_code(image, image_options)
        image = image.wave(amplitude, frequency).shade(true, 20, 60)
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
        image = image.wave(amplitude, frequency).charcoal
      when 'almost_invisible'
        image_options[:color] = 'red'
        append_simple_captcha_code(image, image_options)
        image = image.wave(amplitude, frequency).solarize
      else
        append_simple_captcha_code(image, image_options)
        image = image.wave(amplitude, frequency)
      end
    end

  end

end
