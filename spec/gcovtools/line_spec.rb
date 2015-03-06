require_relative '../spec_helper'

describe GCOVTOOLS::Line do
  describe "#number" do
    it "should return the number it was given" do
      line = GCOVTOOLS::Line.new 2, 4, "abcdef"
      expect(line.number).to eq(2)
    end
  end

  describe "#count" do
    it "should return the count it was given" do
      line = GCOVTOOLS::Line.new 2, 4, "abcdef"
      expect(line.count).to eq(4)
    end
  end

  describe "#text" do
    it "should return the text it was given" do
      line = GCOVTOOLS::Line.new 2, 4, "abcdef"
      expect(line.text).to eq("abcdef")
    end
  end

  describe ".parse" do
    it "should parse gcov format line with count" do
      line = GCOVTOOLS::Line.parse "        2:   55:  std::string StringUtil::ltrim( const std::string &s ) "
      expect(line.number).to eq(55)
      expect(line.count).to eq(2)
      expect(line.text).to eq("  std::string StringUtil::ltrim( const std::string &s ) ")
    end

    it "should parse empty gcov format line" do
      line = GCOVTOOLS::Line.parse "        -:   35:   * don't worry about excessive copying."
      expect(line.number).to eq(35)
      expect(line.count).to eq(:none)
      expect(line.text).to eq("   * don't worry about excessive copying.")
    end

    it "should parse missed gcov format line" do
      line = GCOVTOOLS::Line.parse "    #####:   89:  int somestatement = /*ignored value*/ xyz; }  "
      expect(line.number).to eq(89)
      expect(line.count).to eq(:missed)
      expect(line.text).to eq("  int somestatement = /*ignored value*/ xyz; }  ")
    end

    it "should ignore missed closing brace" do
      line = GCOVTOOLS::Line.parse "    #####:   1:}"
      expect(line.number).to eq(1)
      expect(line.count).to eq(:none)
      expect(line.text).to eq("}")
      line = GCOVTOOLS::Line.parse "    #####:   89:    }  "
      expect(line.number).to eq(89)
      expect(line.count).to eq(:none)
      expect(line.text).to eq("    }  ")
      line = GCOVTOOLS::Line.parse "    #####:   999:                                    }"
      expect(line.number).to eq(999)
      expect(line.count).to eq(:none)
      expect(line.text).to eq("                                    }")
      line = GCOVTOOLS::Line.parse "    #####:   5:}                                  "
      expect(line.number).to eq(5)
      expect(line.count).to eq(:none)
      expect(line.text).to eq("}                                  ")
    end

  end

  describe "#state" do
    it "should return :exec if it has positive count" do
      line = GCOVTOOLS::Line.new 3,5,"line x"
      expect(line.state).to eq(:exec)
    end

    it "should return :missed if it was missed" do
      line = GCOVTOOLS::Line.new 3,:missed,"line x"
      expect(line.state).to eq(:missed)
    end

    it "should return :none if it is not relevant" do
      line = GCOVTOOLS::Line.new 3,:none,"line x"
      expect(line.state).to eq(:none)
    end
  end

  describe "#merge" do
    it "should add hit counts" do
      line = GCOVTOOLS::Line.new 3,4, "abcdef"
      line2 = GCOVTOOLS::Line.new 3,1, "abcdef"
      line3 = line.merge line2
      expect(line3.count).to eq(5)

      line = GCOVTOOLS::Line.new 3,:missed, "abcdef"
      line2 = GCOVTOOLS::Line.new 3,1, "abcdef"
      line3 = line.merge line2
      expect(line3.count).to eq(1)

      line = GCOVTOOLS::Line.new 3,1, "abcdef"
      line2 = GCOVTOOLS::Line.new 3,:missed, "abcdef"
      line3 = line.merge line2
      expect(line3.count).to eq(1)
    end

    it "should give missed (0) presedence over none" do
      line = GCOVTOOLS::Line.new 3,:missed, "abcdef"
      line2 = GCOVTOOLS::Line.new 3,:none, "abcdef"
      line3 = line.merge line2
      expect(line3.count).to eq(:missed)
    end

  end # describe #merge

end
