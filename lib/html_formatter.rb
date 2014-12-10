
require_relative './project'
require_relative './file'
require_relative './line'

require 'erb'
require 'cgi'

module GCOV
  
  class HTMLFormatter
    
    def get_binding # this is only a helper method to access the objects binding method
      binding
    end
    
    def initialize project, va={}
      @project = project
      @css = va[:css]

      if !@css
        @csslink = <<EOF
      <style>

      </style>
EOF
      else
        @csslink = "<link rel=\"stylesheet\" href=\"#{@css}\" />"
      end
      
      @template = ::File.read(::File.join(::File.dirname(__FILE__),"html_view.html.erb"))
    end # initialize
    
    def class_of line
      case line.count
      when :none then "moot"
      when :missed then "missed"
      else "ok"
      end
    end

    def class_of_stat value, &block
      fail "class_of_stat needs a block" unless block_given?
      return ( (yield value) ? "value" : "value_bad" )
    end

    def class_of_file file
      case file.stats[:missed_lines]
      when 0 then "header good"
      else "header bad"
      end
    end

    def encode text
      CGI.escapeHTML( text )
    end

    def print
      
      renderer = ERB.new( @template )
      
      puts renderer.result(self.get_binding)
      
    end # HTMLFormatter#print

  end # HTMLFormatter

end # GCOV
