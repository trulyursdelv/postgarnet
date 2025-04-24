Gem::Specification.new do |s|
  s.name = "postgarnet"
  s.version = "1.0.7"
  s.summary = "Lightweight, on-the-go Gmail SMTP client for Ruby"
  s.description = <<-DESC
Postgarnet is a lightweight SMTP client for sending emails through Gmail using Ruby. It allows full control over server connection and message headers, supports templates with dynamic payloads, and works out of the box with minimal setup. Designed with simplicity in mind, it's ideal for quick and flexible email sending in Ruby scripts and applications.
DESC
  s.authors = ["trulyursdelv"]
  s.files = ["lib/postgarnet.rb"]
  s.homepage = "https://rubygems.org/gems/postgarnet"
  s.license = "CC0-1.0"
  s.required_ruby_version = ">= 3.0"
  s.add_dependency "net-smtp", "~> 0.5.1"
end