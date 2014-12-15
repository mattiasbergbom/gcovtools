
module GCOV

  class Line

    attr_reader :number, :count, :text, :state
    
    def initialize number, count, text
      @number = number
      @count = count
      @text = text
      @state = case @count
               when :missed then :missed
               when :none then :none
               else :exec
               end
    end

    def self.parse line
      match = /^[ ]*([0-9]+|-|#####):[ ]*([0-9]+):(.*)/.match(line)
      fail "Invalid line: #{line}" unless match.to_a.count == 4
      count,number,text = match.to_a[1..3]
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
