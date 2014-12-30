require_relative './file'
require_relative './line'

module GCOV

  class Project
    
    attr_reader :files, :stats
    attr_accessor :name

    def initialize name=""
      @name = name
      @files = {}
      @adding = false
    end

    def <<(file)
      if @files.has_key?file.name
        @files[file.name].merge! file
      else
        @files[file.name] = file
      end
      _update_stats unless @adding
    end

    def files
      @files.sort{|a,b| 
        if ::File.basename(a[0]) < ::File.basename(b[0])
          -1
        elsif ::File.basename(a[0]) == ::File.basename(b[0])
          0
        else
          1
        end }.map{|key,val|val}
    end

    def add_files &block
      # suspend stat updates until done adding files
      fail "add_files requires a block" unless block_given?

      # guard against nested calls
      was_adding = @adding
      @adding = true
      yield
      @adding = was_adding

      _update_stats unless @adding

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
        :hits_per_line => 0
      }

      @files.each do |name,file|
        @stats[:missed_lines] += file.stats[:missed_lines]
        @stats[:exec_lines] += file.stats[:exec_lines]
        @stats[:total_exec] += file.stats[:total_exec]
        @stats[:empty_lines] += file.stats[:empty_lines]
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

    def _add_file path, hash_={}
      hash = hash_.dup
      
      # legacy support
      if !hash[:filter].nil? and ( hash[:filter].is_a? Regexp )
        hash[:filter] = [ hash[:filter] ]
      end
      
      files = GCOV::File.load(path)

      files.each do |file|
        if hash[:filter].nil? or hash[:filter].empty? or hash[:filter].select{|f| f.match(::Pathname.new(file.meta['Source']).cleanpath.to_s) }.empty?
          self << file
        end # if
      end #each file
    end

    def add_dir path, hash_={}
      hash = hash_.dup
      if hash[:recursive] == true
        filenames = Dir["#{path}/**/*.gcov"]
      else
        filenames = Dir["#{path}/*.gcov"]
      end

      add_files do 
        filenames.each do |filename|
          _add_file filename, hash
        end # each filename
      end # add_files
    end # #add_dir
    
    def add_file path, hash_={}
      hash = hash_.dup
      add_files do
        _add_file path, hash
      end # add_files
    end # #add_file

    def self.load_dir path, hash={}
      project = GCOV::Project.new
      project.add_dir path, hash
      project
    end

  end
end
