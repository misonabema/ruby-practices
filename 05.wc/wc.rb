#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  option = set_option
  file_info_list = read_file_info

  output(option, file_info_list)
end

def output(option, file_info_list)
  total_counts = { lines: 0, words: 0, chars: 0 }

  file_info_list.each do |file_info|
    counts = count_content(file_info[:file_content], total_counts)
    print_counts(file_info[:file_name], counts, option)
  end

  print_counts('total', total_counts, option) if ARGV.size > 1
end

def count_content(file_content, total_counts)
  counters = {
    lines: file_content.count("\n"),
    words: file_content.split(/\s+/).count,
    chars: file_content.bytesize
  }

  counters.each do |key, value|
    total_counts[key] += value
  end

  counters
end

def print_counts(file_name, counts, option)
  selected_counts = option.values.any? ? counts.filter_map { |key, value| value if option[key] } : counts.values

  format = selected_counts.map { '%8d' }.join('')
  format += ' %s' unless file_name.empty?

  printf("#{format}\n", *selected_counts, file_name)
end

def set_option
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
