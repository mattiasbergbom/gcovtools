
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
      when :none then "irrelevant"
      when :missed then "missed"
      else "ok"
      end
    end

    def class_of_stat value, error_comp, warning_comp=nil
      if eval("#{value}#{error_comp}")
        return "value_error"
      elsif !warning_comp.nil? and eval("#{value}#{warning_comp}")
        return "value_warning"
      else
        return "value_ok"
      end
    end

    def class_of_file file, error_level, warning_level=nil
      if file.stats[:coverage] <= error_level
        return "header error"
      elsif !warning_level.nil? and file.stats[:coverage] < warning_level
        return "header warning"
      else
        return "header ok"
      end
    end

    def count_of line
      case line.count
      when :none then ""
      when :missed then "<strong>miss</strong>"
      else line.count
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
