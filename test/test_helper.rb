
require 'rubygems'
require 'test/unit'
require 'fileutils'

require File.expand_path('rails_setup', File.dirname(__FILE__))

require 'active_support/test_case'
require 'action_controller/test_case'

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '../lib')
require 'simple_captcha'
