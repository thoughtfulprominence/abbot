require File.join(File.dirname(__FILE__), %w[.. .. spec_helper])

describe Abbot::Buildfile, 'load' do

  include Abbot::SpecHelpers

  it "should load the contents of the buildfile as well as imports" do
    p = fixture_path('buildfiles', 'basic', 'Buildfile')
    b = Abbot::Buildfile.load(p)
    
    b.should_not be_nil
    b.execute_task(:default)
    
    # Found in Buildfile
    RESULTS[:test_task1].should be_true
    
    # Found in import(task_module)
    RESULTS[:imported_task].should be_true
  end
  
  it "should be able to load the contents of one builfile on top of another" do
    a = Abbot::Buildfile.load(fixture_path('buildfiles','installed', 'Buildfile'))
    b = a.dup.load! fixture_path('buildfiles','basic', 'Buildfile')
    
    b.execute_task :default
    
    # Found in Buildfile
    RESULTS[:test_task1].should be_true
    
    # Found in installed/Buildfile
    RESULTS[:installed_task].should be_true
  end
  
  it "should store every loaded path in loaded_paths" do
    ## IMPORTANT! The buildfiles loaded here are not important, but they must
    ## not contain any 'import' directives or else this test will fail.
    path1 = fixture_path('buildfiles','installed', 'Buildfile')
    path2 = fixture_path('buildfiles','installed', 'Buildfile2')
    
    a = Abbot::Buildfile.new
    a.load! path1
    a.load! path2
    
    puts "\na.loaded_paths = #{a.loaded_paths * "\n"}\n"
    a.loaded_paths.size.should eql(2)
    a.loaded_paths.should include(path1)
    a.loaded_paths.should include(path2)
  end
    
end