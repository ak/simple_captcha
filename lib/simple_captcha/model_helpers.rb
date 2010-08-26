# Copyright (c) 2008 [Sur http://expressica.com]

module SimpleCaptcha #:nodoc
  module ModelHelpers #:nodoc
    
    # To implement model based simple captcha use this method in the model as...
    #
    #  class User < ActiveRecord::Base
    #    validates_captcha :message => "Are you a bot?"
    #  end
    # 
    # Configuration options:
    #
    #   * :add_to_base - Specifies if error should be added to base or captcha field. defaults to false.
    #   * :message - A custom error message (default is: "Secret Code did not match with the Image")
    #   * :on - Specifies when this validation is active (default is :save, other options :create, :update)
    #   * :if - Specifies a method, proc or string to call to determine if the validation should occur (e.g. :if => :allow_validation, or :if => Proc.new { |user| user.signup_step > 2 }). The method, proc or string should return or evaluate to a true or false value.
    #   * :unless - Specifies a method, proc or string to call to determine if the validation should not occur (e.g. :unless => :skip_validation, or :unless => Proc.new { |user| user.signup_step <= 2 }). The method, proc or string should return or evaluate to a true or false value.
    
    module ClassMethods
      
      def validates_captcha(options = {})
        configuration = { :on      => :save,
                          :message => "Secret Code did not match with the Image" }
        configuration.update(options)
        
        module_eval do
          include SimpleCaptcha::ConfigTasks
          attr_accessor :captcha, :captcha_key 
          include SimpleCaptcha::ModelHelpers::InstanceMethods
          send(validation_method(configuration[:on]), configuration) do |record|
            if record.captcha_is_valid?
              true
            elsif configuration[:add_to_base] 
              record.errors.add_to_base(configuration[:message]) 
              false
            else
              record.errors.add(:captcha, configuration[:message])
              false
            end
          end
        end
      end

      alias_method :apply_simple_captcha, :validates_captcha
      
    end
    
    module InstanceMethods
      def captcha_is_valid?
        captcha && captcha.upcase.delete(" ") == simple_captcha_value(captcha_key)
      end
    end
    
  end
end

ActiveRecord::Base.module_eval do
  extend SimpleCaptcha::ModelHelpers::ClassMethods
end
