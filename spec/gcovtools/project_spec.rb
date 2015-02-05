require_relative '../spec_helper'

describe GCOVTOOLS::Project do

  describe "#name" do
    it "can be given in the constructor" do
      project = GCOVTOOLS::Project.new "Test"
      expect(project.name).to eq("Test")
    end

    it "is optional in the constructor" do
      project = GCOVTOOLS::Project.new
      expect(project.name).to eq("")
    end

    it "can be modified" do
      project = GCOVTOOLS::Project.new "Test"
      project.name = "Test2"
      expect(project.name).to eq("Test2")
    end
    
  end

  describe "#files" do
    it "returns no files if it is empty" do
      project = GCOVTOOLS::Project.new "Test"
      expect(project.files.count).to eq(0)
    end

    it "returns the files it has been given" do
      project = GCOVTOOLS::Project.new "Test"
      project << GCOVTOOLS::File.new("foobar.cpp")
      project << GCOVTOOLS::File.new("boofar.cpp")
      expect(project.files.count).to eq(2)
      expect(project.files.map(&:name)).to include(a_string_ending_with("foobar.cpp"))
      expect(project.files.map(&:name)).to include(a_string_ending_with("boofar.cpp"))
    end
  end

  describe ".load_dir" do
    it "loads all files in the given directory" do
      project = GCOVTOOLS::Project.load_dir(File.join(File.dirname(__FILE__),"data"))
      expect(project.files.count).to eq(3)
      expect(project.files.map{|file|file.name}).to include(a_string_ending_with("test2.cpp"))
      expect(project.files.map{|file|file.name}).not_to include(a_string_ending_with("test3.cpp"))
    end
    
    it "recursively loads all files in the given directory structure" do
      project = GCOVTOOLS::Project.load_dir(File.join(File.dirname(__FILE__),"data"), :recursive => true)
      expect(project.files.count).to eq(4)
      expect(project.files.map{|file|file.name}).to include(a_string_ending_with("test2.cpp"))
      expect(project.files.map{|file|file.name}).to include( a_string_ending_with("test3.cpp") )
    end

  end

  describe "#add_file" do
    it "should add the given file" do
      project = GCOVTOOLS::Project.new
      project.add_file(File.join(File.dirname(__FILE__),"data","test2.cpp.gcov"))
      expect(project.files.count).to eq(1)
      expect(project.files[0].name).to eq( "test2.cpp" )
    end

    it "should split concatenated gcov files into multiple objects" do
      project = GCOVTOOLS::Project.new
      project.add_file(File.join(File.dirname(__FILE__),"concat","test_cat.cpp.gcov"))
      expect(project.files.count).to eq(2)
      expect(project.files.map(&:name)).to include( "test.cpp" )
      expect(project.files.map(&:name)).to include( "test1.cpp" )
    end

    it "should filter using given array of expressions" do
      project = GCOVTOOLS::Project.new
      project.add_file(File.join(File.dirname(__FILE__),"data","test2.cpp.gcov"), :exclude => [/test2\.cpp/,/test3\.cpp/])
      expect(project.files.count).to eq(0)
    end

    it "should filter out concatenated files that match the filter" do
      project = GCOVTOOLS::Project.new
      project.add_file(File.join(File.dirname(__FILE__),"concat","test_cat.cpp.gcov"), :exclude => [/test\.cpp$/])
      expect(project.files.count).to eq(1)
      expect(project.files.map(&:name)).not_to include( a_string_ending_with("test.cpp") )
      expect(project.files.map(&:name)).to include( a_string_ending_with("test1.cpp") )
    end

    it "should not filter out concatenated files that don't match the filter" do
      project = GCOVTOOLS::Project.new
      project.add_file(File.join(File.dirname(__FILE__),"concat","test_cat.cpp.gcov"), :exclude => [/test_cat\.cpp\.gcov$/])
      expect(project.files.count).to eq(2)
      expect(project.files.map(&:name)).to include( a_string_ending_with("test.cpp") )
      expect(project.files.map(&:name)).to include( a_string_ending_with("test1.cpp") )
    end

    it "should filter inclusively if told to" do
      project = GCOVTOOLS::Project.new
      project.add_file(File.join(File.dirname(__FILE__),"concat","test_cat.cpp.gcov"), :include => [/test\.cpp$/] )
      expect(project.files.count).to eq(1)
      expect(project.files.map(&:name)).not_to include( a_string_ending_with("test1.cpp") )
      expect(project.files.map(&:name)).to include( a_string_ending_with("test.cpp") )
    end

    it "should apply all inclusive filters" do
      project = GCOVTOOLS::Project.new
      project.add_file(File.join(File.dirname(__FILE__),"concat","test_cat.cpp.gcov"), :include => [/test\.cpp$/,/test1\.cpp$/] )
      expect(project.files.count).to eq(2)
      expect(project.files.map(&:name)).to include( a_string_ending_with("test1.cpp") )
      expect(project.files.map(&:name)).to include( a_string_ending_with("test.cpp") )
    end

    it "should apply exclusive filters after inclusive ones" do
      project = GCOVTOOLS::Project.new
      project.add_file(File.join(File.dirname(__FILE__),"concat","test_cat.cpp.gcov"), :include => [/test.*\.cpp$/], :exclude => [/test.cpp/] )
      expect(project.files.count).to eq(1)
      expect(project.files.map(&:name)).to include( a_string_ending_with("test1.cpp") )
      expect(project.files.map(&:name)).not_to include( a_string_ending_with("test.cpp") )
    end

    it "should merge file stats for identical filenames" do
      project = GCOVTOOLS::Project.new
      project.add_files do
        file = GCOVTOOLS::File.new "myfile.cpp"
        file.add_lines do
          file << GCOVTOOLS::Line.new(0,:none,"Source:myfile.cpp")
          file << GCOVTOOLS::Line.new(1,4,"line 1")
          file << GCOVTOOLS::Line.new(2,23,"line 2")
          file << GCOVTOOLS::Line.new(3,:none,"line 3")
          file << GCOVTOOLS::Line.new(4,:missed,"line 4")
          file << GCOVTOOLS::Line.new(5,:none,"line 5")
        end

        project << file

        file = GCOVTOOLS::File.new "myfile.cpp"
        file.add_lines do
          file << GCOVTOOLS::Line.new(0,:none,"Source:myfile.cpp")
          file << GCOVTOOLS::Line.new(1,:missed,"line 1")
          file << GCOVTOOLS::Line.new(2,40,"line 2")
          file << GCOVTOOLS::Line.new(3,:none,"line 3")
          file << GCOVTOOLS::Line.new(4,:none,"line 4")
        end

        project << file
        
      end # add_files

      expect(project.files.count).to eq(1)
      
    end # it

  end # describe

  describe "#add_dir" do
    it "adds all files in the given directory" do
      project = GCOVTOOLS::Project.load_dir(File.join(File.dirname(__FILE__),"data","data2"))
      project.add_dir(File.join(File.dirname(__FILE__),"data"))
      expect(project.files.count).to eq(4)
      expect(project.files.map{|file|file.name}).to include( a_string_ending_with("test2.cpp") )
      expect(project.files.map{|file|file.name}).to include( a_string_ending_with("test3.cpp") )
    end

    it "recursively adds all files in the given directory" do
      project = GCOVTOOLS::Project.new
      project.add_dir(File.join(File.dirname(__FILE__),"data"), :recursive => true)
      expect(project.files.count).to eq(4)
      expect(project.files.map{|file|file.name}).to include( a_string_ending_with("test2.cpp") )
      expect(project.files.map{|file|file.name}).to include( a_string_ending_with("test3.cpp") )
    end

    it "filters using given singular expression" do
      project = GCOVTOOLS::Project.new
      project.add_dir(File.join(File.dirname(__FILE__),"data"), :recursive => true, :exclude => [/test2\.cpp/])
      expect(project.files.count).to eq(3)
      expect(project.files.map{|file|file.name}).not_to include( a_string_ending_with("test2.cpp") )
      expect(project.files.map{|file|file.name}).to include( a_string_ending_with("test3.cpp") )
    end

    it "filters using given array of expressions" do
      project = GCOVTOOLS::Project.new
      project.add_dir(File.join(File.dirname(__FILE__),"data"), :recursive => true, :exclude => [/test2\.cpp/,/test3\.cpp/])
      expect(project.files.count).to eq(2)
      expect(project.files.map{|file|file.name}).not_to include( a_string_ending_with("test2.cpp") )
      expect(project.files.map{|file|file.name}).not_to include( a_string_ending_with("test3.cpp") )
    end

    it "should filter out concatenated files that match the filter" do
      project = GCOVTOOLS::Project.new
      project.add_dir(File.join(File.dirname(__FILE__),"concat"), :recursive => true, :exclude => [/test\.cpp$/])
      expect(project.files.count).to eq(1)
      expect(project.files.map(&:name)).not_to include( a_string_ending_with("test.cpp") )
      expect(project.files.map(&:name)).to include( a_string_ending_with("test1.cpp") )
    end

    it "should not filter out concatenated files that don't match the filter" do
      project = GCOVTOOLS::Project.new
      project.add_dir(File.join(File.dirname(__FILE__),"concat"), :recursive => true, :exclude => [/test_cat\.cpp/])
      expect(project.files.count).to eq(2)
      expect(project.files.map(&:name)).to include( a_string_ending_with("test.cpp") )
      expect(project.files.map(&:name)).to include( a_string_ending_with("test1.cpp") )
    end

    it "should filter inclusively if told to" do
      project = GCOVTOOLS::Project.new
      project.add_dir(File.join(File.dirname(__FILE__),"concat"), :recursive => true, :include => [/test\.cpp/])
      expect(project.files.count).to eq(1)
      expect(project.files.map(&:name)).not_to include( a_string_ending_with("test1.cpp") )
      expect(project.files.map(&:name)).to include( a_string_ending_with("test.cpp") )
    end

    it "should apply all inclusive filters" do
      project = GCOVTOOLS::Project.new
      project.add_dir(File.join(File.dirname(__FILE__),"concat"), :recursive => true, :include => [/test\.cpp$/,/test1\.cpp$/] )
      expect(project.files.count).to eq(2)
      expect(project.files.map(&:name)).to include( a_string_ending_with("test1.cpp") )
      expect(project.files.map(&:name)).to include( a_string_ending_with("test.cpp") )
    end

    it "should apply exclusive filters after inclusive ones" do
      project = GCOVTOOLS::Project.new
      project.add_dir(File.join(File.dirname(__FILE__),"concat"), :recursive => true, :include => [/test.*\.cpp$/], :exclude => [/test.cpp/] )
      expect(project.files.count).to eq(1)
      expect(project.files.map(&:name)).to include( a_string_ending_with("test1.cpp") )
      expect(project.files.map(&:name)).not_to include( a_string_ending_with("test.cpp") )
    end

  end


  describe "#stats" do
    it "should be computed based on file stats" do
      project = GCOVTOOLS::Project.new

      project.add_files do
        file = GCOVTOOLS::File.new "myfile.cpp"
        file.add_lines do
          file << GCOVTOOLS::Line.new(1,4,"line 1")
          file << GCOVTOOLS::Line.new(2,23,"line 2")
          file << GCOVTOOLS::Line.new(3,:none,"line 3")
          file << GCOVTOOLS::Line.new(4,:missed,"line 4")
          file << GCOVTOOLS::Line.new(5,:none,"line 5")
        end

        project << file

        file = GCOVTOOLS::File.new "myfile2.cpp"
        file.add_lines do
          file << GCOVTOOLS::Line.new(1,:missed,"line 1")
          file << GCOVTOOLS::Line.new(2,40,"line 2")
          file << GCOVTOOLS::Line.new(3,:none,"line 3")
          file << GCOVTOOLS::Line.new(4,:none,"line 4")
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

    it "should be computed based on file stats" do
      project = GCOVTOOLS::Project.new

      project.add_files do
        file = GCOVTOOLS::File.new "myfile.cpp"
        file.add_lines do
          file << GCOVTOOLS::Line.new(1,:none,"line 1")
          file << GCOVTOOLS::Line.new(2,:none,"line 2")
          file << GCOVTOOLS::Line.new(3,:none,"line 3")
          file << GCOVTOOLS::Line.new(4,:none,"line 4")
        end

        project << file

        file = GCOVTOOLS::File.new "myfile2.cpp"
        file.add_lines do
          file << GCOVTOOLS::Line.new(1,:none,"line 1")
          file << GCOVTOOLS::Line.new(2,:none,"line 2")
        end

        project << file
        
      end
      
      expect(project.stats[:lines]).to eq(0)
      expect(project.stats[:coverage]).to eq(1)
      expect(project.stats[:hits_per_line]).to eq(0)

    end # it
  end # describe #stats

end # describe Project
