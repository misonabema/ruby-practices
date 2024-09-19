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
  file_type = case
              when status.directory?
                'd'
              when status.file?
                '-'
              when status.symlink?
                'l'
              when status.blockdev?
                'b'
              when status.chardev?
                'c'
              when status.pipe?
                'p'
              when status.socket?
                's'
              else
                '?'
              end
  
  permissions = (0..2).map do |i|
    shift = i * 3
    r = (status.mode >> (6 - shift)) & 0o4 > 0 ? 'r' : '-'
    w = (status.mode >> (6 - shift)) & 0o2 > 0 ? 'w' : '-'
    x = (status.mode >> (6 - shift)) & 0o1 > 0 ? 'x' : '-'
    r + w + x
  end.join

  file_type + permissions
end

def blocks_total(entries)
  total_blocks = entries.sum {|file| File.lstat(file).blocks}
  puts "total #{total_blocks}"
end

def l_option(entries)
  blocks_total(entries)
  entries.each do |file|
    status = File.lstat(file)
    mode = files(status)
    nlink = status.nlink
    user = Etc.getpwuid(status.uid).name
    group = Etc.getgrgid(status.gid).name
    size = status.size
    mtime = status.mtime.strftime('%b %d %H:%M')
    printf("%<mode>s %<nlink>2d %<user>s  %<group>s %<size>5d %<mtime>s %<file>s\n",
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
