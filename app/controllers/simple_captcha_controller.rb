# Copyright (c) 2008 [Sur http://expressica.com]

class SimpleCaptchaController < ActionController::Base
  include SimpleCaptcha::ImageHelpers

  def show  #:nodoc
    send_data(
      generate_simple_captcha_image(
        :image_style => params[:image_style],
        :distortion => params[:distortion], 
        :simple_captcha_key => params[:simple_captcha_key] || params[:captcha_key]),
      :type => 'image/jpeg',
      :disposition => 'inline',
      :filename => 'simple_captcha.jpg')
  end
  alias_method :simple_captcha, :show # backward compatibility
  
end
