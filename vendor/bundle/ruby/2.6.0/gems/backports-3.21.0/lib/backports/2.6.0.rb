# require this file to load all the backports up to Ruby 2.6
require 'backports/2.5.0'
Backports.require_relative_dir if RUBY_VERSION < '2.6'
