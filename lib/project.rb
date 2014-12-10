require_relative './file'
require_relative './line'

module GCOV

  class Project
    
    attr_reader :files
    attr_accessor :name

    def initialize name=""
      @name = name
      @files = []
    end

    def <<(file)
      @files << file
    end

    def demangle filename
      result = filename
      if start = result.index(/###/)
        result = result[start..-1]
      end
      
      result.gsub!( /(###|#|\^|\.gcov$)/, {"###"=>"/","#"=>"/","^"=>"..",".gcov"=>""} ) 
      STDERR.puts "demangled: #{result}"
      result = ::File.realpath(result)
      STDERR.puts "realpath: #{result}"
      result
    end

    def add_dir path, hash={}
      if hash[:recursive] == true
        filenames = Dir["#{path}/**/*.gcov"]
      else
        filenames = Dir["#{path}/*.gcov"]
      end
      STDERR.puts "filenames: #{filenames}"
      
      filenames.select{|filename| ( hash[:filter].nil? or !hash[:filter].match(demangle(filename))) }.map{|filename| GCOV::File.load filename }.each do |file|
        if hash[:filter].nil? or !hash[:filter].match( ::File.realpath(file.meta['Source']) )
          self << file
        end
      end # files
      STDERR.puts "files: #{files.map{|f|f.name}}"
    end

    def add_file path, hash={}
      if hash[:filter].nil? or !hash[:filter].match(demangle(path)) 
        file = GCOV::File.load(path)
        if hash[:filter].nil? or !hash[:filter].match( ::File.realpath(file.meta['Source']) )
          self << file
        end # if
      end # if
    end # add_file

    def self.load_dir path, hash={}
      project = GCOV::Project.new
      project.add_dir path, hash
      project
    end

  end
end
