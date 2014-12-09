require 'project'

describe GCOV::Project do
  describe "#files" do
    it "returns no files if it is empty" do
      project = GCOV::Project.new
      expect(project.files.count).to eq(0)
    end

    it "returns the files it has been given" do
      project = GCOV::Project.new
      project << GCOV::File.new("foobar.cpp")
      project << GCOV::File.new("boofar.cpp")
      expect(project.files.count).to eq(2)
      expect(project.files[0].name).to eq("foobar.cpp")
      expect(project.files[1].name).to eq("boofar.cpp")
    end
  end

  describe ".load_dir" do
    it "finds all files in a directory" do
      project = GCOV::Project.load_dir(File.join(File.dirname(__FILE__),"data"))
      expect(project.files.count).to eq(3)
      expect(project.files.map{|file|file.name}).to include(a_string_ending_with("test2.cpp.gcov"))
      expect(project.files.map{|file|file.name}).not_to include(a_string_ending_with("test3.cpp.gcov"))
    end
    
    it "recursively finds all files in a directory structure" do
      project = GCOV::Project.load_dir(File.join(File.dirname(__FILE__),"data"), :recursive => true)
      expect(project.files.count).to eq(4)
      expect(project.files.map{|file|file.name}).to include( a_string_ending_with("test3.cpp.gcov") )
    end
  end
end
