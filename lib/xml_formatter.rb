
require_relative './project'
require_relative './file'
require_relative './line'

# require 'gyoku'
require 'builder'

module GCOVTOOLS
  
  class XMLFormatter
    
    def initialize project, va={}
      @project = project
      @xsl = va[:xsl]
      
      # @hash = { :files => { :file => [] } }
      @xml = Builder::XmlMarkup.new( :indent => 2 )
      @xml.instruct! :xml, :encoding => "UTF-8"

      if @xsl
        @xml.instruct! :"xml-stylesheet", :href => @xsl, :type => "text/xsl"
      end
      
      @xml.projects do |xprojects|
        xprojects.project(:name=>"Test") do |xproject|
          xproject.files do |xfiles|
            @project.files.each do |file|
              xfiles.file(:name => file.name) do |xfile|
                xfile.lines do |xlines|
                  file.lines.select{|line| line.number > 0}.each do |line|
                    xlines.line(:number=>line.number,:count=>line.count) do |xline|
                      xline.count line.count
                      xline.text do |xtext|
                        xtext.cdata! line.text
                      end # xtext
                    end # xline
                  end # line
                end # xlines
              end # xfile
            end # file
          end # xfiles
        end # xproject
      end # xprojects
    end # initialize
    
    def print
      # puts "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
      # if @xslt
      #   puts "<?xml-stylesheet href=\"#{@xslt}\" type=\"text/xsl\"?>"
      # end
      # puts Gyoku.xml( @hash )
      puts @xml.target!
    end # XMLFormatter#print

  end # XMLFormatter

end # GCOVTOOLS
