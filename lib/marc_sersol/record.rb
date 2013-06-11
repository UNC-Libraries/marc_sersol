require 'marc'

module MARC
# This class extends the MARC::Record class with SerialsSolutions-specific methods
  class Record

# Creates an alphabetized, deduped array of libraries claiming record's packages

    def libs
      pkgs = self.packages
      @libs = []
      pkgs.each do |pname|
        pkg = Package.lookup(pname)
        pkg.libraries.each {|lib| @libs << lib.code}
      end #pkgs.each do |pkg|
      @liblist = @libs.uniq.sort
    end #def liblist

# Performs ssib > sseb and ssj > sse replacements
    def localize001
      thef = self.find {|f| f.tag =~ /^001/}
      theval = thef.value
      #puts "Original 001: #{theval.rjust(25)}"
      if theval =~ /^ssib/
        theval.gsub!(/ssib/, 'sseb')
      elsif theval =~ /^ssj/
        theval.gsub!(/ssj/, 'sse')
      end #if theval
      #puts "New 001: #{theval.rjust(25)}\n\n"
    end #def localize001

# Returns array of package names from 856x.
    def packages
      # set up array to bump pkg names into
      _856xs = []
      # put each 856 field in an array
      _856fields = self.find_all {|f| f.tag =~ /^856/}
      #puts "#{_856fields.length} _856fields found by RecSet: #{_856fields.inspect}"

      # iterate over each 856 field, pulling out the $x(s) into a holder array
      _856fields.each do |field|
        _856xholder = field.find_all {|sf| sf.code == 'x'}
        #puts "_856xholder found by RecSet: #{_856xholder.inspect}"

        # pushes each name (just the name!) from a $x that has been collected
        # in the holder into the array for the entire field
        _856xholder.each do |x|
          _856xs.push(x.to_s[3..-2])
          #puts "_856xs found by RecSet: #{_856xs.inspect}"
        end #_856xholder.each do
      end #856fields.each do
      #puts "Packages recorded from MARC record: #{_856xs.sort.uniq}"
      return _856xs.sort.uniq
    end #def packages

  end #class
end #module