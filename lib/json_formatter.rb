
require_relative './project'
require_relative './file'
require_relative './line'

require 'json'

module GCOVTOOLSTOOLS
  
  class JSONFormatter
    
    def initialize project, va={}
      @project = project

      @json = {
        'files' => []
      }

      @project.files.each do |file|
        @json['files'] << { 
          'name' => file.name,
          'meta' => file.meta,
          'stats' => file.stats,
          'lines' => []
        }

        file.lines.select{|line| line.number > 0}.each do |line|
          @json['files'][-1]['lines'] << { 
            'number' => line.number,
            'count' => line.count,
            'text' => line.text
          } 
        end # each line
      end # each file
    end # initialize
    
    def print
      puts @json.to_json
    end # JSONFormatter#print

  end # JSONFormatter

end # GCOVTOOLSTOOLS
