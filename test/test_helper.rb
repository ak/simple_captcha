
require 'rubygems'

require 'active_support'

# Make double-sure the RAILS_ENV is set to test :
silence_warnings { RAILS_ENV = "test" }
silence_warnings { RAILS_ROOT = File.join(File.dirname(__FILE__), 'root') }

require 'active_support/dependencies'

include ActiveSupport # setup auto loading as would happen in Rails :
Dependencies.load_paths << File.join(File.dirname(__FILE__), '..', 'lib')

#require 'action_controller'
#require 'action_view/helpers'

require 'test/unit'
require 'active_support/test_case'
