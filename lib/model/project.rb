require 'model/file'
require 'model/line'

class Project
  
  attr_reader :files

  def initialize
    @files = []
  end

  def <<(file)
    @files << file
  end

end
