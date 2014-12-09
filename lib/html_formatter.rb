
require_relative './project'
require_relative './file'
require_relative './line'

require 'erb'

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
        table.project, td.header, td.line {
        border: 1px solid black;
        }

        table.project {
           padding:0px;
           border:0px;
           border-spacing: 0px;
           border-collapse: separate;
        }

        tr.ok {
          background-color:#bbffbb;
          padding-top: 0px;
          padding-bottom: 0px;
          padding-left: 0px;
          padding-right: 0px;
          margin:0px;
        }

        tr.none {
          background-color:#f8f8f8;
          padding-top: 0px;
          padding-bottom: 0px;
          padding-left: 0px;
          padding-right: 0px;
        }

        tr.missed {
          background-color:#ffbbbb;
          padding-top: 0px;
          padding-bottom: 0px;
          padding-left: 0px;
          padding-right: 0px;
        }

        .code {
          height: 10pt; 
          padding-top: 0px;
          padding-bottom: 0px;
          padding-left: 0px;
          padding-right: 0px;
          vertical-align:top;
          margin-top: 0px;
        }

        div.code {
          font-size:8pt         
        }

        td.file {
          font-weight:bold;
          font-color:black
        }  
      </style>
EOF
      else
        @csslink = "<link rel=\"stylesheet\" href=\"#{@css}\" />"
      end
      
      @template = ::File.read(::File.join(::File.dirname(__FILE__),"html_view.html.erb"))
    end # initialize
    
    def class_of line
      case line.count
      when :none then "none"
      when :missed then "missed"
      else "ok"
      end
    end

    def print
      
      renderer = ERB.new( @template )
      
      puts renderer.result(self.get_binding)
      
    end # HTMLFormatter#print

  end # HTMLFormatter

end # GCOV
