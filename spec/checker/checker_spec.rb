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

  it 'should return false for nil' do
    @spell.exists?(nil).should == false
  end

  it 'should return false for non-String' do
    @spell.exists?(:word).should == false
  end

  it 'should return true if option exclude_alphabet is false, and word is a letter' do
    @spell.options = {exclude_alphabet: false}
    @spell.exists?('x').should == true
    @spell.exists?('X').should == true
  end

  it 'should return false if option exclude_alphabet is true, and word is a letter' do
    @spell.options = {exclude_alphabet: true}
    @spell.exists?('x').should == false
    @spell.exists?('X').should == false
  end

  it 'should use options passed to exist? 1' do
    @spell.options = {exclude_alphabet: false}
    @spell.exists?('h', {exclude_alphabet: true}).should == false
  end

  it 'should use options passed to exist? 2' do
    @spell.options = {exclude_alphabet: true}
    @spell.exists?('h', {exclude_alphabet: false}).should == true
  end

  # TODO: Profile
  it "shouldn't take forever to find a lot of words" do
    words = %w{ all bad cap dad eat fad glad had inch jump kind lend monster on put quiet run sad tape under vector was xenophobe yes zebra }

    words *= 100

    words.each { |word| @spell.exists?(word).should == true }
  end

end