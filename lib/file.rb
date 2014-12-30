require_relative './line'
require 'pathname'

class TrueClass
  def to_i
    return 1
  end
end

class FalseClass
  def to_i
    return 0
  end
end

module GCOV

  class File

    attr_reader :name, :lines, :meta, :stats

    def initialize name
      fail "name required" unless name and name.is_a? String
      @name = name
      @lines = []
      @meta = {}
      @stats = {}
      _update_stats
    end

    def add_lines &block
      fail "add_lines requires a block" unless block_given?
      @adding = true
      yield
      @adding = false
      _update_stats
    end

    def _update_stats
      @stats = { 
        :missed_lines => 0,
        :exec_lines => 0,
        :empty_lines => 0,
        :total_exec => 0,
        :total_lines => 0,
        :lines => 0,
        :coverage => 0.0,
        :hits_per_line => 0.0
      }

      @lines.each do |line|
        @stats[:missed_lines] += (line.state == :missed).to_i
        @stats[:exec_lines] += (line.state == :exec).to_i
        @stats[:total_exec] += (line.count.is_a?(Integer) ? line.count : 0 )
        @stats[:empty_lines] += (line.state == :none).to_i
      end
      
      @stats[:lines] = @stats[:exec_lines] + @stats[:missed_lines]
      @stats[:total_lines] = @stats[:lines] + @stats[:empty_lines]

      if @stats[:lines] > 0 
        @stats[:coverage] = @stats[:exec_lines].to_f / @stats[:lines].to_f
        @stats[:hits_per_line] = @stats[:total_exec].to_f / @stats[:lines]
      else
        @stats[:coverage] = 1
        @stats[:hits_per_line] = 0
      end
      
      @stats[:coverage_s] = sprintf("%0.01f%",100.0*@stats[:coverage])
      @stats[:hits_per_line_s] = sprintf("%0.02f",@stats[:hits_per_line])

    end

    def _add_line line
      if line.number == 0
        key,val = /([^:]+):(.*)$/.match(line.text).to_a[1..2]
        @meta[key] = val
      else
        @lines << line
      end
    end

    def <<(line)
      fail "need to be in add_lines block" unless @adding
      _add_line line
    end

    def self.load filename
      files = []
      file = nil
      ::File.open(filename, "r") do |file_handle|
        file_handle.each_line do |line_|
          line = GCOV::Line.parse(line_)
          if line.number == 0
            key,val = /([^:]+):(.*)$/.match(line.text).to_a[1..2]
            if key == 'Source'
              if !file.nil?
                file._update_stats
                files << file
              end # if
              file = GCOV::File.new val
            end # if source
          end # if line == 0
          file._add_line line
        end # each line
      end# file_handle
      file._update_stats
      files << file
      files
    end

    def self.demangle filename
      result = filename.dup
      if start = result.index(/###/)
        result = result[start..-1]
      end
      
      result.gsub!( /(###|#|\^|\.gcov$)/, {"###"=>"/","#"=>"/","^"=>"..",".gcov"=>""} ) 
      result = ::Pathname.new(result).cleanpath.to_s
      result
    end

  end # class File

end
