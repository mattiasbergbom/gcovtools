require 'file'
require 'line'

module GCOV

  class Project
    
    attr_reader :files

    def initialize
      @files = []
    end

    def <<(file)
      @files << file
    end

    def self.load_dir path, hash={}
      project = GCOV::Project.new

      if hash[:recursive] == true
        filenames = Dir["#{path}/**/*.gcov"]
      else
        filenames = Dir["#{path}/*.gcov"]
      end

      filenames.map{|filename| GCOV::File.load filename }.each do |file|
        project << file
      end

      project
    end

  end
end
