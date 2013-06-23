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

  it "shouldn't take forever to find a lot of words" do
    words = %w{ all bad cap dad eat fad glad had inch jump kind lend monster on put quiet run sad tape under vector was xenophobe yes zebra }

    words *= 100

    words.each { |word| @spell.exists?(word).should == true }
  end

end