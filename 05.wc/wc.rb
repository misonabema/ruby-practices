#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def option
  options = { lines: false, words: false, chars: false }
  OptionParser.new do |opts|
    options.each_key do |key|
      opts.on("-#{key[0]}") { options[key] = true }
    end
  end.parse!

  options
end

def file_read
  if ARGV.empty?
    [{ file_content: ARGF.read, file_name: '' }]
  else
    ARGV.map do |file_name|
      { file_content: File.read(file_name), file_name: }
    end
  end
end

def counter(options, file_content)
  counters = {
    lines: file_content.count("\n"),
    words: file_content.split(/\s+/).count,
    chars: file_content.bytesize
  }

  count = []
  counters.each do |key, value|
    count << value if options[key]
  end
  count = counters.values if count.empty?

  count
end

def output(file_name, counts)
  format = counts.map { '%8d' }.join('')
  format += ' %s' unless file_name.empty?

  if file_name.empty?
    printf("#{format}\n", *counts)
  else
    printf("#{format}\n", *counts, file_name)
  end
end

def multi_files(options)
  file_info = file_read
  total_counts = nil

  file_info.each do |files|
    counts = counter(options, files[:file_content])
    total_counts ||= Array.new(counts.size, 0)

    output(files[:file_name], counts)

    counts.each_with_index do |count, index|
      total_counts[index] += count
    end
  end

  return unless ARGV.size > 1

  format = "#{total_counts.map { '%8d' }.join('')} total\n"
  printf(format, *total_counts)
end

options = option
multi_files(options)
