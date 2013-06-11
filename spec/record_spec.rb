require 'marc'
require './lib/marc_sersol/record'

describe MARC::Record do

  describe "localize001" do
    before(:each) do
      @recs = []
      MARC::Reader.new('test/data/ssid_test.mrc').each {|rec| @recs << rec}
    end
    it "Changes ssib to sseb" do
      rec = @recs[0]
      rec.localize001
      rec['001'].value.should =~ /^sseb/
    end
    it "Changes ssj to sse" do
      rec = @recs[1]
      rec.localize001
      rec['001'].value.should =~ /^sse\d/
    end
  end

  describe "packages" do
    before(:each) do
      @recs = []
      MARC::Reader.new('test/data/packages.mrc').each {|rec| @recs << rec}
    end
    it "one 856, one package" do
      rec = @recs[0]
      rec.packages.should == ['Health Source: Doctor\'s Edition']
    end
    it "one 856, more than one package (sorts alphabetically)" do
      rec = @recs[1]
      rec.packages.should == ['MATHnetBASE', 'Springer']
    end
    it "more than one 856, more than one package (deduplicates)" do
      rec = @recs[2]
      rec.packages.should == ['Black Drama (Second Edition)', 'Black Thought and Culture', 'Computer Database']
    end
  end
end

