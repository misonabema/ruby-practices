#!/usr/bin/env ruby

require 'date'
require 'optparse'
present = Date.today

params = ARGV.getopts("m:y:")
month = params["m"]&.to_i || present.month
year = params["y"]&.to_i || present.year

puts "#{month}月 #{year}".center(20) 

puts "日 月 火 水 木 金 土"

initial_day = Date.new(year, month, 1) 
last_day = Date.new(year, month, -1) 

print "   " * initial_day.wday
(initial_day..last_day).each do |date| 
  if date.day <= 9
    print " #{date.day} "
  else
    print "#{date.day} "
  end

  if date.saturday?
    puts "\n"
  end
end
