require 'model/file'
require 'model/line'

describe File do

  it "requires a filename" do
    expect{ file = File.new }.to raise_error
  end
  
  describe "#name" do
    it "returns the filename it was given" do
      file = File.new "myfile.cpp"
      expect(file.name).to eq("myfile.cpp")
    end
  end

  describe "#lines" do
    it "returns no lines by default" do
      file = File.new "myfile.cpp"
      expect(file.lines.count).to eq(0)
    end
    
    it "returns the lines it was given" do
      file = File.new "myfile.cpp"
      file << Line.new(1,4,"line 1")
      file << Line.new(2,23,"line 2")
      expect(file.lines.count).to eq(2)
      expect(file.lines[0].number).to eq(1)
      expect(file.lines[1].number).to eq(2)
    end
    
  end
end
