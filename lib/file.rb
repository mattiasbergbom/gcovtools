require 'line'

module GCOV

  class File

    attr_reader :name, :lines

    def initialize name
      fail "name required" unless name and name.is_a? String
      @name = name
      @lines = []
    end

    def <<(line)
      @lines << line
    end
  end

end
