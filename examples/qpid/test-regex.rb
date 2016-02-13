#!/usr/bin/env ruby
#
def watch_for(file, pattern)
  f = File.open(file,"r")
  f.seek(0,IO::SEEK_END)
  while true do
    select([f])
    line = f.gets
    puts "Found it! #{line}" if line=~pattern
  end
end

#watch_for("test.log",//)

array = { :x => 1, :b => 2}

puts array.inspect

name = "accccccc-1234"

puts name.length
if name.length < 1
  puts "Hey"
end

if name.match(/[A-Z]/) || name.match('_')
  puts "Matched upper case or underscore"
else
  puts "No upper case letters"
end

if name.match('_')
  puts "Matched Underscore"
else
  puts "No Underscore"
end
