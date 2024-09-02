#!/usr/bin/env ruby

WIDTH = 24

def entry(dir = Dir.pwd)
  entries = Dir.entries(dir).sort
  entries.reject { |file| file[0] == '.' }
end

def output(col = 2)
  row = entry.count.div(col)

  align_entry = Array.new(row) { Array.new(col) }
  entry.each_with_index do |item, i|
    entry_row = i % row
    entry_col = i / row
    align_entry[entry_row][entry_col] = item
  end

  align_entry.each do |line|
    line.each do |item|
      print item.to_s.ljust(WIDTH)
    end
    puts "\n"
  end
end

output
