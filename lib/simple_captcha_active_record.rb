# Copyright (c) 2008 [Sur http://expressica.com]

module SimpleCaptcha #:nodoc
  module ModelHelpers #:nodoc
    
    # To implement model based simple captcha use this method in the model as...
    #
    #  class User < ActiveRecord::Base
    #
    #    apply_simple_captcha :message => "my customized message"
    #    validate_on_create :captcha_is_valid?
    #  end
    #
    # Alternatively you can write your own
    module ClassMethods
      def apply_simple_captcha(options = {})
        instance_variable_set(:@add_to_base, options[:add_to_base])
        instance_variable_set(:@captcha_invalid_message, options[:message] || "Secret Code did not match with the Image")
        module_eval do
          include SimpleCaptcha::ConfigTasks
          attr_accessor :captcha, :captcha_key #, :authenticate_with_captcha
          # alias_method :valid_without_captcha?, :valid?
          # alias_method :save_without_captcha, :save
          include SimpleCaptcha::ModelHelpers::InstanceMethods
        end
      end
    end
    
    module InstanceMethods
     def captcha_is_valid?
        if captcha && captcha.upcase.delete(" ") == simple_captcha_value(captcha_key)
          true
        elsif self.class.instance_variable_get(:@add_to_base) == true 
          self.errors.add_to_base(
            self.class.instance_variable_get(:@captcha_invalid_message)) 
          false
        else
          self.errors.add(:captcha, 
            self.class.instance_variable_get(:@captcha_invalid_message))
          false
        end
      end
    end
  end
end

ActiveRecord::Base.module_eval do
  extend SimpleCaptcha::ModelHelpers::ClassMethods
end
