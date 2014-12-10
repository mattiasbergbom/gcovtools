require_relative './spec_helper'

describe GCOV::File do

  it "requires a filename" do
    expect{ file = GCOV::File.new }.to raise_error
  end
  
  describe "#name" do
    it "returns the filename it was given" do
      file = GCOV::File.new "myfile.cpp"
      expect(file.name).to eq("myfile.cpp")
    end
  end

  describe "#<<" do
    it "doesn't allow adding lines outside of the add_lines block" do
      file = GCOV::File.new "myfile.cpp"
      expect{ 
        file << GCOV::Line.new(1,4,"line 1")
      }.to raise_error
    end
  end

  describe "#add_lines" do
    it "computes stats after adding lines" do
      file = GCOV::File.new "myfile.cpp"
      file.add_lines do
        file << GCOV::Line.new(1,4,"line 1")
        file << GCOV::Line.new(2,23,"line 2")
        file << GCOV::Line.new(3,:none,"line 3")
        file << GCOV::Line.new(4,:missed,"line 4")
        file << GCOV::Line.new(5,:missed,"line 5")
      end
      expect(file.stats[:lines]).to eq(4)
      expect(file.stats[:total_lines]).to eq(5)
      expect(file.stats[:total_exec]).to eq(27)
      expect(file.stats[:empty_lines]).to eq(1)
      expect(file.stats[:exec_lines]).to eq(2)
      expect(file.stats[:missed_lines]).to eq(2)
      expect(file.stats[:coverage]).to eq(0.5)
      expect(file.stats[:total_exec]).to eq(27)
    end
  end

  describe "#lines" do
    it "returns no lines by default" do
      file = GCOV::File.new "myfile.cpp"
      expect(file.lines.count).to eq(0)
    end
    
    it "returns the lines it was given" do
      file = GCOV::File.new "myfile.cpp"
      file.add_lines do
        file << GCOV::Line.new(1,4,"line 1")
        file << GCOV::Line.new(2,23,"line 2")
      end
      expect(file.lines.count).to eq(2)
      expect(file.lines[0].number).to eq(1)
      expect(file.lines[1].number).to eq(2)
    end
    
  end

  describe ".load" do
    it "can load a gcov file" do
      file = GCOV::File.load(File.join(File.dirname(__FILE__),"data/test.cpp.gcov"))
      expect(file.lines.count).to eq(9)
      expect(file.meta["Graph"]).to eq("test.gcno")
      expect(file.meta["Runs"].to_i).to eq(1)
    end
  end
end
