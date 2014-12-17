require_relative '../spec_helper'

describe GCOV::Line do
  describe "#number" do
    it "returns the number it was given" do
      line = GCOV::Line.new 2, 4, "abcdef"
      expect(line.number).to eq(2)
    end
  end

  describe "#count" do
    it "returns the count it was given" do
      line = GCOV::Line.new 2, 4, "abcdef"
      expect(line.count).to eq(4)
    end
  end

  describe "#text" do
    it "returns the text it was given" do
      line = GCOV::Line.new 2, 4, "abcdef"
      expect(line.text).to eq("abcdef")
    end
  end

  describe ".parse" do
    it "parses gcov format line with count" do
      line = GCOV::Line.parse "        2:   55:  std::string StringUtil::ltrim( const std::string &s ) "
      expect(line.number).to eq(55)
      expect(line.count).to eq(2)
      expect(line.text).to eq("  std::string StringUtil::ltrim( const std::string &s ) ")
    end

    it "parses empty gcov format line" do
      line = GCOV::Line.parse "        -:   35:   * don't worry about excessive copying."
      expect(line.number).to eq(35)
      expect(line.count).to eq(:none)
      expect(line.text).to eq("   * don't worry about excessive copying.")
    end

    it "parses missed gcov format line" do
      line = GCOV::Line.parse "    #####:   89:  }  "
      expect(line.number).to eq(89)
      expect(line.count).to eq(:missed)
      expect(line.text).to eq("  }  ")
    end

  end

end
