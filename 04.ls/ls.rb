#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'
WIDTH = 24

options = ARGV.getopts('arl')

def entry(options)
  flags = options['a'] ? File::FNM_DOTMATCH : 0
  Dir.glob('*', flags, sort: true)
end

def files(status)
  types = { 'file' => '_', 'directory' => 'd', 'link' => 'l' }
  permission = status.mode.to_s(8)[-3..].chars.map do |n|
    n.to_i.to_s(2).rjust(3, '0').gsub('1', 'rwx').tr('0', '_')
  end
  types[status.ftype] + permission.join
end

def l_option(entries)
  entries.each do |file|
    status = File.lstat(file)
    mode = files(status)
    nlink = status.nlink
    user = Etc.getpwuid(status.uid).name
    group = Etc.getgrgid(status.gid).name
    size = status.size
    mtime = status.mtime.strftime('%b %d %H:%M')
    printf("%<mode>s %<nlink>2d %<user>s %<group>s %<size>5d %<mtime>s %<file>s\n",
           mode:, nlink:, user:, group:, size:, mtime:, file:)
  end
end

def others(entries, col)
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

def output(options, col = 3)
  entries = entry(options)
  entries.reverse! if options['r']

  if options['l']
    l_option(entries)
  else
    others(entries, col)
  end
end

output(options)
