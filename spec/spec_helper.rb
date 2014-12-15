# encoding: utf-8

require 'simplecov'
SimpleCov.start

require_relative '../lib/line'
require_relative '../lib/file'
require_relative '../lib/project'

$LOAD_PATH << File.expand_path(File.join('..', 'lib'), File.dirname(__FILE__))

