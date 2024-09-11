#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
WIDTH = 24

options = ARGV.getopts('a')

def entry(options)
  if options['a']
    Dir.glob('*', File::FNM_DOTMATCH).sort
  else
    Dir.glob('*').sort
  end
end

def output(options, col = 3)
  entries = entry(options)
  row = (entries.count.to_f / col).ceil

  align_entry = Array.new(row) { Array.new(col) }
  entries.each_with_index do |item, i|
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

output(options)
