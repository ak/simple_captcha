# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
  s.name = "simple_captcha"
  s.version = '2.1.1'

  s.authors = ["Sur"]
  s.date = Date.today
  s.description = "Its implementation requires adding up a single line in views and in controllers/models. SimpleCaptcha is available to be used with Rails2.0 or above and also it provides the backward compatibility with previous versions of Rails."
  s.summary = "SimpleCaptcha is the simplest and a robust captcha plugin"
  s.files = Dir.glob("{app,lib}/**/*")
  s.homepage = %q{http://expressica.com/simple_captcha/}
  s.require_paths = ["app", "lib"]
  s.rubyforge_project = %q{simple_captcha}
  s.rubygems_version = %q{1.3.5}
  s.specification_version = 1

end
