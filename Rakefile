# Copyright (c) 2008 [Sur http://expressica.com]

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the simple_captcha plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the simple_captcha plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'SimpleCaptcha'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc 'Generate captcha image samples.'
Rake::TestTask.new(:generate_samples) do |t|
  $:.unshift File.join(File.dirname(__FILE__), 'lib')

  require 'action_view'
  require 'active_record'
  require 'simple_captcha'
  # prefer quick_magick (works on JRuby as well) :
  begin
    require 'quick_magick'
    require 'simple_captcha/quick_magick_backend'
    SimpleCaptcha.backend = :quick_magick
  rescue nil
    require 'simple_captcha/r_magick_backend'
    SimpleCaptcha.backend = :RMagick
  end

  include SimpleCaptcha::ViewHelpers
  include SimpleCaptcha::ImageHelpers

  def self.simple_captcha_value(key) # stub
    generate_simple_captcha_data
  end

  samples_dir = File.join(File.dirname(__FILE__), 'samples')
  image_styles = %w{ embosed_silver simply_red simply_green simply_blue distorted_black all_black charcoal_grey almost_invisible }

  (image_styles + [ nil ]).each do |image_style|
    simple_captcha_img = generate_simple_captcha_image(:image_style => image_style)
    filename = File.join(samples_dir, (image_style || 'default') + '.jpg')
    File.open(filename, "wb") { |file| file << simple_captcha_img }
  end

end
