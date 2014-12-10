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

    def add_dir path, hash={}
      if hash[:recursive] == true
        filenames = Dir["#{path}/**/*.gcov"]
      else
        filenames = Dir["#{path}/*.gcov"]
      end
      
      filenames.map{|filename| GCOV::File.load filename }.each do |file|
        self << file
      end
    end

    def add_file path
      self << GCOV::File.load(path)
    end

    def self.load_dir path, hash={}
      project = GCOV::Project.new
      project.add_dir path, hash
      project
    end

  end
end
