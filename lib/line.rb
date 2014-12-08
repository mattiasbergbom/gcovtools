
module GCOV

  class Line

    attr_reader :number, :count, :text
    
    def initialize number, count, text
      @number = number
      @count = count
      @text = text
    end

    def self.parse line
      count,number,text = line.split(":",3)
      number = number.to_i
      count = case count.strip
      when "-" then :none
      when "#####" then :missed
      else count.to_i
      end
      GCOV::Line.new number,count,text
    end

  end

end
