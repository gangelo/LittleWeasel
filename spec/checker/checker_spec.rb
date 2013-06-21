require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LittleWeasel do

  before do
    @spell = LittleWeasel::Checker.instance
  end
  
  it 'should create a LittleWeasel object' do
    @spell.should be_an_instance_of LittleWeasel::Checker
  end
  
  it 'should return true for valid word' do
    @spell.exists?('apple').should == true
  end

  it 'should return false for invalid word' do
    @spell.exists?('appel').should == false
  end

end