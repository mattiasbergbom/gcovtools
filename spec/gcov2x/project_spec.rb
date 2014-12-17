require_relative '../spec_helper'

describe GCOV::Project do

  describe "#name" do
    it "can be given in the constructor" do
      project = GCOV::Project.new "Test"
      expect(project.name).to eq("Test")
    end

    it "is optional in the constructor" do
      project = GCOV::Project.new
      expect(project.name).to eq("")
    end

    it "can be modified" do
      project = GCOV::Project.new "Test"
      project.name = "Test2"
      expect(project.name).to eq("Test2")
    end
    
  end

  describe "#files" do
    it "returns no files if it is empty" do
      project = GCOV::Project.new "Test"
      expect(project.files.count).to eq(0)
    end

    it "returns the files it has been given" do
      project = GCOV::Project.new "Test"
      project << GCOV::File.new("foobar.cpp")
      project << GCOV::File.new("boofar.cpp")
      expect(project.files.count).to eq(2)
      expect(project.files[0].name).to eq("foobar.cpp")
      expect(project.files[1].name).to eq("boofar.cpp")
    end
  end

  describe ".load_dir" do
    it "loads all files in the given directory" do
      project = GCOV::Project.load_dir(File.join(File.dirname(__FILE__),"data"))
      expect(project.files.count).to eq(3)
      expect(project.files.map{|file|file.name}).to include(a_string_ending_with("test2.cpp.gcov"))
      expect(project.files.map{|file|file.name}).not_to include(a_string_ending_with("test3.cpp.gcov"))
    end
    
    it "recursively loads all files in the given directory structure" do
      project = GCOV::Project.load_dir(File.join(File.dirname(__FILE__),"data"), :recursive => true)
      expect(project.files.count).to eq(4)
      expect(project.files.map{|file|file.name}).to include(a_string_ending_with("test2.cpp.gcov"))
      expect(project.files.map{|file|file.name}).to include( a_string_ending_with("test3.cpp.gcov") )
    end

  end

  describe "#add_file" do
    it "adds the given file" do
      project = GCOV::Project.new
      project.add_file(File.join(File.dirname(__FILE__),"data","test2.cpp.gcov"))
      expect(project.files.map{|file|file.name}).to include( a_string_ending_with("test2.cpp.gcov") )
    end
  end

  describe "#add_dir" do
    it "adds all files in the given directory" do
      project = GCOV::Project.load_dir(File.join(File.dirname(__FILE__),"data","data2"))
      project.add_dir(File.join(File.dirname(__FILE__),"data"))
      expect(project.files.count).to eq(4)
      expect(project.files.map{|file|file.name}).to include( a_string_ending_with("test2.cpp.gcov") )
      expect(project.files.map{|file|file.name}).to include( a_string_ending_with("test3.cpp.gcov") )
    end

    it "recursively adds all files in the given directory" do
      project = GCOV::Project.new
      project.add_dir(File.join(File.dirname(__FILE__),"data"), :recursive => true)
      expect(project.files.count).to eq(4)
      expect(project.files.map{|file|file.name}).to include( a_string_ending_with("test2.cpp.gcov") )
      expect(project.files.map{|file|file.name}).to include( a_string_ending_with("test3.cpp.gcov") )
    end
  end


  describe "#stats" do
    it "should be computed based on file stats" do
      project = GCOV::Project.new

      project.add_files do
        file = GCOV::File.new "myfile.cpp"
        file.add_lines do
          file << GCOV::Line.new(1,4,"line 1")
          file << GCOV::Line.new(2,23,"line 2")
          file << GCOV::Line.new(3,:none,"line 3")
          file << GCOV::Line.new(4,:missed,"line 4")
          file << GCOV::Line.new(5,:none,"line 5")
        end

        project << file

        file = GCOV::File.new "myfile.cpp"
        file.add_lines do
          file << GCOV::Line.new(1,:missed,"line 1")
          file << GCOV::Line.new(2,40,"line 2")
          file << GCOV::Line.new(3,:none,"line 3")
          file << GCOV::Line.new(4,:none,"line 4")
        end

        project << file
        
      end
      
      expect(project.stats[:lines]).to eq(5)
      expect(project.stats[:total_lines]).to eq(9)
      expect(project.stats[:total_exec]).to eq(67)
      expect(project.stats[:empty_lines]).to eq(4)
      expect(project.stats[:exec_lines]).to eq(3)
      expect(project.stats[:missed_lines]).to eq(2)
      expect(project.stats[:coverage]).to eq(3.0/5)
      expect(project.stats[:hits_per_line]).to eq(67.0/5)

    end      
  end
end
