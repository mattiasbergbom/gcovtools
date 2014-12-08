require 'model/project'

describe Project do
  describe "#files" do
    it "returns no files if it is empty" do
      project = Project.new
      project.files.count.should == 0
    end

    it "returns the files it has been given" do
      project = Project.new
      project << File.new("foobar.cpp")
      project << File.new("boofar.cpp")
      project.files.count.should == 2
      expect(project.files[0].name).to eq("foobar.cpp")
      expect(project.files[1].name).to eq("boofar.cpp")
    end
  end
end
