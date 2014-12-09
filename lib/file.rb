require_relative './line'

module GCOV

  class File

    attr_reader :name, :lines, :meta

    def initialize name
      fail "name required" unless name and name.is_a? String
      @name = name
      @lines = []
      @meta = {}
    end

    def <<(line)
      if line.number == 0
        key,val = /([^:]+):(.*)$/.match(line.text).to_a[1..2]
        @meta[key] = val
      else
        @lines << line
      end
    end

    def self.load filename
      file = GCOV::File.new filename
      ::File.open(filename, "r") do |file_handle|
        file_handle.each_line do |line|
          file << GCOV::Line.parse(line)
        end
      end
      file
    end
  end

end
