require_relative '../spec_helper'

describe GCOVTOOLS::File do

  it "requires a filename" do
    expect{ file = GCOVTOOLS::File.new }.to raise_error
  end
  
  describe "#name" do
    it "returns the filename it was given" do
      file = GCOVTOOLS::File.new "myfile.cpp"
      expect(file.name).to eq("myfile.cpp")
    end
  end

  describe "#<<" do
    it "doesn't allow adding lines outside of the add_lines block" do
      file = GCOVTOOLS::File.new "myfile.cpp"
      expect{ 
        file << GCOVTOOLS::Line.new(1,4,"line 1")
      }.to raise_error
    end
  end

  describe "#add_lines" do
    it "computes stats after adding lines" do
      file = GCOVTOOLS::File.new "myfile.cpp"
      file.add_lines do
        file << GCOVTOOLS::Line.new(1,4,"line 1")
        file << GCOVTOOLS::Line.new(2,23,"line 2")
        file << GCOVTOOLS::Line.new(3,:none,"line 3")
        file << GCOVTOOLS::Line.new(4,:missed,"line 4")
        file << GCOVTOOLS::Line.new(5,:missed,"line 5")
      end
      expect(file.stats[:lines]).to eq(4)
      expect(file.stats[:total_lines]).to eq(5)
      expect(file.stats[:total_exec]).to eq(27)
      expect(file.stats[:empty_lines]).to eq(1)
      expect(file.stats[:exec_lines]).to eq(2)
      expect(file.stats[:missed_lines]).to eq(2)
      expect(file.stats[:coverage]).to eq(0.5)
      expect(file.stats[:hits_per_line]).to eq(27.0/4)
    end

    it "handles files with 0 executable lines" do
      file = GCOVTOOLS::File.new "myfile.cpp"
      file.add_lines do
        file << GCOVTOOLS::Line.new(1,:none,"line 1")
        file << GCOVTOOLS::Line.new(2,:none,"line 2")
        file << GCOVTOOLS::Line.new(3,:none,"line 3")
        file << GCOVTOOLS::Line.new(4,:none,"line 4")
      end
      expect(file.stats[:lines]).to eq(0)
      expect(file.stats[:coverage]).to eq(1)
      expect(file.stats[:hits_per_line]).to eq(0)
    end
  end

  describe "#lines" do
    it "returns no lines by default" do
      file = GCOVTOOLS::File.new "myfile.cpp"
      expect(file.lines.count).to eq(0)
    end
    
    it "should return the lines it was given, sorted by number" do
      file = GCOVTOOLS::File.new "myfile.cpp"
      file.add_lines do
        file << GCOVTOOLS::Line.new(2,23,"line 2")
        file << GCOVTOOLS::Line.new(1,4,"line 1")
      end
      expect(file.lines.count).to eq(2)
      expect(file.lines[0].number).to eq(1)
      expect(file.lines[1].number).to eq(2)
    end
    
  end

  describe ".load" do
    it "can load a gcov file" do
      file = GCOVTOOLS::File.load(File.join(File.dirname(__FILE__),"data/test.cpp.gcov"))[0]
      expect(file.lines.count).to eq(9)
      expect(file.meta["Graph"]).to eq("test.gcno")
      expect(file.meta["Runs"].to_i).to eq(1)
    end

    it "should split concatenated gcov files into multiple objects" do
      files = GCOVTOOLS::File.load(File.join(File.dirname(__FILE__),"concat/test_cat.cpp.gcov"))
      
      expect(files.count).to eq(2)
      expect(files[0].meta["Source"]).to eq("test.cpp")
      expect(files[1].meta["Source"]).to eq("test1.cpp")

      expect(files[0].lines.count).to eq(9)
      expect(files[0].meta["Graph"]).to eq("test.gcno")
      expect(files[0].meta["Runs"].to_i).to eq(1)
    end
  end

  describe ".demangle" do
    it "should demangle file names with nonexisting components" do
      demangled = GCOVTOOLS::File.demangle( "testfile.cpp.###Applications#Xcode.app#Nonexisting#Path#Contents#Developer#Toolchains#XcodeDefault.xctoolchain#usr#bin#^#include#c++#v1#streambuf.gcov" )
      expect( demangled ).to eq("/Applications/Xcode.app/Nonexisting/Path/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1/streambuf")
    end
  end

  describe "#merge" do

    it "should merge the counts of each line and recompute stats" do
      file = GCOVTOOLS::File.new "myfile.cpp"
      file.add_lines do
        file << GCOVTOOLS::Line.new(1,4,"line 1")
        file << GCOVTOOLS::Line.new(2,23,"line 2")
        file << GCOVTOOLS::Line.new(3,:none,"line 3")
        file << GCOVTOOLS::Line.new(4,:missed,"line 4")
        file << GCOVTOOLS::Line.new(5,:missed,"line 5")
      end

      file2 = GCOVTOOLS::File.new "myfile.cpp"
      file2.add_lines do
        file2 << GCOVTOOLS::Line.new(1,1,"line 1")
        file2 << GCOVTOOLS::Line.new(2,:missed,"line 2")
        file2 << GCOVTOOLS::Line.new(3,:none,"line 3")
        file2 << GCOVTOOLS::Line.new(4,4,"line 4")
        file2 << GCOVTOOLS::Line.new(5,:missed,"line 5")
      end

      file3 = file.merge file2

      expect(file3.stats[:lines]).to eq(4)
      expect(file3.stats[:total_lines]).to eq(5)
      expect(file3.stats[:total_exec]).to eq(32)
      expect(file3.stats[:empty_lines]).to eq(1)
      expect(file3.stats[:exec_lines]).to eq(3)
      expect(file3.stats[:missed_lines]).to eq(1)
      expect(file3.stats[:coverage]).to eq(0.75)
      expect(file3.stats[:hits_per_line]).to eq(32.0/4)

    end # it
  end # describe
end
