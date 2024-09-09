#!/usr/bin/env ruby

WIDTH = 24

def entry(file = '*')
  Dir.glob(file).sort
end

def output(col = 3)
  row = (entry.count.to_f / col).ceil

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
    puts
  end
end

output
