
module GCOVTOOLS

  class Line

    attr_reader :number, :count, :text
    
    def initialize number, count, text
      @number = number
      @count = count
      @text = text
    end

    def state
      case @count
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
      count = :none if count == :missed and text.strip == "}"
      GCOVTOOLS::Line.new number,count,text
    end

    def merge! other
      if other.count.is_a? Integer and @count.is_a? Integer
        @count += other.count
      elsif other.count.is_a? Integer
        @count = other.count
      elsif @count.is_a? Integer
        nil
      elsif other.count == :missed or @count == :missed
        @count = :missed
      end
    end

    def merge other
      result = self.dup
      result.merge! other
      result
    end

  end

end
