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

  end
end
