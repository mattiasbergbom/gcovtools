require 'model/line'

describe Line do
  describe "#number" do
    it "returns the number it was given" do
      line = Line.new 2, 4, "abcdef"
      line.number.should == 2
    end
  end

  describe "#count" do
    it "returns the count it was given" do
      line = Line.new 2, 4, "abcdef"
      line.count.should == 4
    end
  end

  describe "#text" do
    it "returns the text it was given" do
      line = Line.new 2, 4, "abcdef"
      line.text.should == "abcdef"
    end
  end

end
