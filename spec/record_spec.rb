require 'marc_sersol'

describe MARC::Record do

  describe "localize001" do
    before(:each) do
      @recs = []
      MARC::Reader.new('test/data/ssid_test.mrc').each {|rec| @recs << rec}
    end
    it "Changes ssib to sseb" do
      rec = @recs[0]
      rec.localize001
      expect(rec['001'].value).to match(/^sseb/)
    end
    it "Changes ssj to sse" do
      rec = @recs[1]
      rec.localize001
      expect(rec['001'].value).to match(/^sse\d/)
    end
  end

  describe "packages" do
    before(:each) do
      @recs = []
      MARC::Reader.new('test/data/packages.mrc').each {|rec| @recs << rec}
    end
    it "one 856, one package" do
      rec = @recs[0]
      expect(rec.packages).to eq(['Health Source: Doctor\'s Edition'])
    end
    it "one 856, more than one package (sorts alphabetically)" do
      rec = @recs[1]
      expect(rec.packages).to eq(['MATHnetBASE', 'Springer'])
    end
    it "more than one 856, more than one package (deduplicates)" do
      rec = @recs[2]
      expect(rec.packages).to eq(['Black Drama (Second Edition)', 'Black Thought and Culture', 'Computer Database'])
    end
  end
end
