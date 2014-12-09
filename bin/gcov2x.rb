#!/usr/bin/env ruby

require 'mixlib/cli'

require_relative '../lib/gcov2x'
require_relative '../lib/ansii_printer'


class CGOV_CLI
  include Mixlib::CLI
  
  # option :config_file, 
  #   :short => "-c CONFIG",
  #   :long  => "--config CONFIG",
  #   :default => 'config.rb',
  #   :description => "The configuration file to use"

  # option :log_level, 
  #   :short => "-l LEVEL",
  #   :long  => "--log_level LEVEL",
  #   :description => "Set the log level (debug, info, warn, error, fatal)",
  #   :required => true,
  #   :proc => Proc.new { |l| l.to_sym }
  
  option :format,
  :short => "-f FORMAT",
  :long => "--format FORMAT",
  :description => "The output format (ascii, xml, json)",
  :proc => Proc.new { |f| f.to_sym }
  
  option :recursive,
  :short => "-r",
  :long => "--recursive",
  :description => "Recursively load all .gcov files in the given directory",
  :on => :tail,
  :boolean => true
  
  option :help,
  :short => "-h",
  :long => "--help",
  :description => "Show this message",
  :on => :tail,
  :boolean => true,
  :show_options => true,
  :exit => 0
  
end

cli = CGOV_CLI.new
filename = cli.parse_options

fail "Got no filename" unless filename.is_a? Array and filename.count > 0
fail "Too many arguments" unless filename.count == 1
fail "Invalid filename" unless filename[0].is_a? String and filename[0].size > 0

if File.directory? filename[0]
  proj = GCOV::Project.load_dir filename[0], :recursive => cli.config[:recursive]
elsif File.file? filename[0]
  fail "-r flag is invalid with a single file" unless !cli.config[:recursive]
  proj = GCOV::Project.new
  proj << GCOV::File.load(filename[0])
end

case cli.config[:format]
when :ascii then
  printer = GCOV::ANSIIPrinter.new proj
  printer.print
when :xml then
  fail "XML export not implemented yet"
when :json then
  fail "json export not implemented yet"
else
  fail "Invalid format"
end

