require 'term/ansicolor'
include Term::ANSIColor

require_relative './project'
require_relative './file'
require_relative './line'

module GCOV
  
  class ANSIIPrinter
    
    def initialize project
      @project = project
    end
    
    def print
      
      @project.files.each do |file|
        file.lines.each do |line|
          col = case line.count
                when :none then dark+white
                when :missed then black+on_red
                else green
                end
          puts col + line.text + reset
        end
      end

    end

  end

end