#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'
WIDTH = 24

options = ARGV.getopts('alr')

def entry(options)
  flags = options['a'] ? File::FNM_DOTMATCH : 0
  Dir.glob('*', flags, sort: true)
end

def file_type(status)
  file_type_hash = {
    directory?: 'd',
    file?: '-',
    symlink?: 'l',
    blockdev?: 'b',
    chardev?: 'c',
    pipe?: 'p',
    socket?: 's'
  }

  file_type_hash.find { |method, _| status.send(method) }&.last || '?'
end

def permissions(status)
  (0..2).map do |i|
    shift = i * 3
    bit_char_hash = { 0o4 => 'r', 0o2 => 'w', 0o1 => 'x' }

    bit_char_hash.map do |bit, char|
      ((status.mode >> (6 - shift)) & bit).positive? ? char : '-'
    end.join
  end.join
end

def files(status)
  file_type(status) + permissions(status)
end

def symlink_path(file)
  if File.symlink?(file)
    " -> #{File.readlink(file)}"
  else
    ''
  end
end

def blocks_total(entries)
  total_blocks = entries.sum { |file| File.lstat(file).blocks }
  puts "total #{total_blocks}"
end

def list_long_format(entries)
  blocks_total(entries)
  entries.each do |file|
    status = File.lstat(file)
    mode = files(status)
    nlink = status.nlink
    user = Etc.getpwuid(status.uid).name
    group = Etc.getgrgid(status.gid).name
    size = status.size
    mtime = status.mtime.strftime('%b %d %H:%M')
    path = symlink_path(file)
    printf("%<mode>s %<nlink>2d %<user>s  %<group>s %<size>5d %<mtime>s %<file>s%<path>s\n",
           mode:, nlink:, user:, group:, size:, mtime:, file:, path:)
  end
end

def list_short_format(entries, col)
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
    list_long_format(entries)
  else
    list_short_format(entries, col)
  end
end

output(options)
