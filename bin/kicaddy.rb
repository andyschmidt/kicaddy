#!/usr/bin/env ruby
require 'optimist'
require 'devenv'
require 'kicaddy'
require 'fileutils'

OPTS = Optimist::options do
  version "#{$0} 1.0 (c) 2021 by Andreas Schmidt"
  banner <<-EOS
With KiCaddy you can easily create KiCad symbols and footprints for matrix boards.
All you need is a simple text file with the pin names.

Usage:
       kicaddy [options] <filename>

where [options] are:
EOS
  opt :spacing, "spacing (mm) of pin columns of footprint", :type => :string
  opt :outdir, "output directory for symbol and footprint file", :type => :string, :default => "/tmp/kicaddy"
  opt :name, "module name", :type => :string, :default => "kicaddy"
end

Optimist.die :spacing, "Need the spacing of pin columns (multiple of 2.54)" unless OPTS[:spacing]

pin_file = ARGV[0]
raise "no valid pinfile given" unless pin_file
raise "no valid pinfile given" unless File.exist?(pin_file)

pins = File.readlines(pin_file)
pins.map!{|p| p.strip }
raise "number of pins must be equal" unless pins.length % 2 == 0

symbol = KiCaddy::SymbolEmp.new OPTS[:name], *pins

odir = OPTS[:outdir]
FileUtils.mkdir_p(odir)
sym_file = "#{OPTS[:name].gsub(/\s+/,'')}.lib"
ofile = File.join(odir, sym_file)
puts "+ writing symbol to #{ofile}"
File.open(ofile, 'w') {|f| f.puts symbol.to_s }

footprint = KiCaddy::FootprintEmp.new(OPTS[:name], num_pads: pins.length, spacing: OPTS[:spacing])
fp_file = "#{OPTS[:name].gsub(/\s+/,'')}.emp"
ofile = File.join(odir, fp_file)
puts "+ writing footprint to #{ofile}"
File.open(ofile, 'w') {|f| f.puts footprint.to_s }
