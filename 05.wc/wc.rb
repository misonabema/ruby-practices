#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  option = option_hash
  file_info = read_file_info

  output(option, file_info)
end

def output(option, file_info)
  total_counts = nil

  file_info.each do |file|
    counts = count_content(option, file[:file_content])
    total_counts ||= Array.new(counts.size, 0)

    print_counts(file[:file_name], counts)

    counts.each_with_index do |count, index|
      total_counts[index] += count
    end
  end

  print_counts('', total_counts, total: true) if ARGV.size > 1
end

def count_content(option, file_content)
  counters = {
    lines: file_content.count("\n"),
    words: file_content.split(/\s+/).count,
    chars: file_content.bytesize
  }
  option.values.any? ? counters.filter_map { |key, value| value if option[key] } : counters.values
end

def print_counts(file_name, counts, total: false)
  format = counts.map { '%8d' }.join('')

  label = total ? 'total' : file_name
  format += ' %s' unless label.empty?

  printf("#{format}\n", *counts, label)
end

def option_hash
  options = { lines: false, words: false, chars: false }
  OptionParser.new do |opt|
    options.each_key do |key|
      opt.on("-#{key[0]}") { options[key] = true }
    end
  end.parse!

  options
end

def read_file_info
  if ARGV.empty?
    [{ file_content: ARGF.read, file_name: '' }]
  else
    ARGV.map do |file_name|
      { file_content: File.read(file_name), file_name: }
    end
  end
end

main
