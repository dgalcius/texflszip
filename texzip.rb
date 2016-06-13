require 'fileutils'
include FileUtils::Verbose

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


Kernel.system("zip #{infile}.zip -m #{tempdir}/*.* >/dev/null")
FileUtils.rm_rf tempdir
puts "#{infile}.zip written ..."



