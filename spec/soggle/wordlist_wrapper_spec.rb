require "spec_helper"

describe Soggle::WordlistWrapper do
  describe "#new" do
    it "should init without errors given a valid file name" do
      expect{Soggle::WordlistWrapper.new('wordlists/american_english_70')}.to_not raise_error
    end
    it "should raise exception given an invalid file name" do
      expect{Soggle::WordlistWrapper.new('doesnt_exist')}.to raise_error(Errno::ENOENT)
    end
  end
  describe "#any_starts_with?" do
    wordlist=StringIO.new <<-WORDLIST
    about
    absolute
    back
    bass
    cat
    czech
    dingo
    zebra
    WORDLIST
    subject{Soggle::WordlistWrapper.new(wordlist)}
    %w[ab ba ca ze].each do |prefix|
      it "should return true for prefix #{prefix}" do
        subject.any_starts_with?(prefix).should be_true
      end
    end
    %w[aaa bz cx].each do |prefix|
      it "should return false for invalid prefix #{prefix}" do
        subject.any_starts_with?(prefix).should be_false
      end
    end
  end
  describe "#words" do
    wordlist=StringIO.new <<-WORDLIST
    America
    apple
    orange
    roast
    WORDLIST
    subject{@wordlist||=Soggle::WordlistWrapper.new(wordlist); @wordlist.words}
    2.times do
      it {should include(*%W[america apple orange roast])}
    end
  end
  describe "#words_starting_with" do
    wordlist=StringIO.new <<-WORDLIST
    ab
    about
    abuse
    cab
    rabbit
    WORDLIST
    subject{Soggle::WordlistWrapper.new(wordlist).words_starting_with(string)}
    context "when string is 'ab'" do
      let(:string){'ab'}
      it {should =~ %w[ab about abuse]}
    end
  end
  describe "#completion_options" do
    wordlist=StringIO.new <<-WORDLIST
    aardvark
    ab
    abs
    about
    abuse
    absolute
    absolve
    acount
    cat
    cab
    cabby
    WORDLIST
    subject{Soggle::WordlistWrapper.new(wordlist).completion_options(prefix)}
    context "when prefix is 'a'" do
      let(:prefix){'a'}
      it{ should =~ %w[a b c]}
    end
    context "when prefix is 'ab'" do
      let(:prefix){'ab'}
      it{ should =~ %w[! s o u]}
    end
    context "when prefix is 'abs'" do
      let(:prefix){'abs'}
      it{ should =~ %w[! o]}
    end
    context "when prefix is 'abso'" do
      let(:prefix){'abso'}
      it{ should =~ %w[l]}
    end
  end
  describe "delegate methods" do
    wordlist=StringIO.new "hello"
    subject{Soggle::WordlistWrapper.new(wordlist)}
    %w[each any? select none?].each do |method|
      it {should respond_to(method.to_sym)}
    end
  end
end
