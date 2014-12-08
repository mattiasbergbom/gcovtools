#!/usr/bin/env ruby

require_relative '../lib/gcov2x'
require_relative '../lib/ansii_printer'

filename = ARGV.pop

fail "Got no filename" unless !filename.nil? 
fail "Invalid filename" unless filename.is_a? String and filename.size > 0

proj = GCOV::Project.new
proj << GCOV::File.parse(filename)

printer = GCOV::ANSIIPrinter.new proj
printer.print
