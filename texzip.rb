require 'fileutils'
require 'optparse'
include FileUtils::Verbose

prgname = 'texzip'
prgfullname = 'Collect tex files recorder in fls'
prgversion = '0.0.1'
prgcredit = 'deimantas.galcius@gmail.com'
options = {}
optparse = OptionParser.new do|opts|
   # Set a banner, displayed at the top
   # of the help screen.
   opts.banner = "Usage: #{prgname} [OPTIONS] <fls-file>\n #{prgfullname}.\n  "
   opts.define_tail "\nEmail bug reports to #{prgcredit}"
   # Define the options, and what they do
   options[:debug] = false
     opts.on( '-d', '--debug [DEBUG]', 'Print debug info (not implemented)' ) do |x|
     options[:debug] = x
   end
   options[:verbose] = false
     opts.on( '--verbose', 'Be verbose (not implemened)' ) do
     options[:verbose] = true
   end
   options[:compress] = true
     opts.on('-n', '--no-compress', 'Do not create zip file' ) do
     options[:compress] = false
   end
   opts.on( '-v', '--version', 'Print version' ) do
      puts "#{prgfullname}, v.#{prgversion}. #{prgcredit}"
      exit
   end
   opts.on( '-h', '--help', 'Display this screen' ) do
     puts opts
     exit
   end
 end

begin
optparse.parse!
rescue OptionParser::InvalidOption => e
 puts e
 puts optparse
 exit 1
end



inputfile = ARGV[0]

if inputfile.nil?
 puts "texzip <ms>"
 exit
end
infile = File.basename(inputfile, '.*') + ".fls"

puts inputfile

File.delete(infile + ".zip") if File.exist?(infile + ".zip")

fls_entries = Array.new;

f = File.open(infile, "r"); lines = f.readlines; f.close

lines.each{|r|
  if (r =~/(INPUT|OUTPUT)\s(.*?)\n/) then
    temp=$2
     if (temp !~/(\.fmtx|\.tfmx)/) then
       if !fls_entries.include?(temp) then
         if File.exists?(temp) then
           fls_entries.push(temp)
         end
         end 
       end
    end
}



tempdir = "source"
FileUtils.rm_rf tempdir  if File.exist?(tempdir)
FileUtils.mkdir tempdir


fls_entries.each{|r|
  if (r =~ /\//) then
    FileUtils.cp r, tempdir, :verbose => true
  end
}
if options[:compress] then
 Kernel.system("zip #{infile}.zip -m #{tempdir}/*.* >/dev/null")
 FileUtils.rm_rf tempdir
 puts "#{infile}.zip written ..."
else
  puts "Files written to #{tempdir}"
end



