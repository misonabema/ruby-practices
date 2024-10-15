#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  options = parse_options
  file_info_list = build_file_info_list

  output(options, file_info_list)
end

def output(options, file_info_list)
  total_counts = { lines: 0, words: 0, chars: 0 }

  file_info_list.each do |file_info|
    counts = count_content(file_info[:file_content])
    counts.each do |key, value|
      total_counts[key] += value
    end
    print_counts(file_info[:file_name], counts, options)
  end

  print_counts('total', total_counts, options) if ARGV.size > 1
end

def count_content(file_content)
  {
    lines: file_content.count("\n"),
    words: file_content.split(/\s+/).count,
    chars: file_content.bytesize
  }
end

def print_counts(file_name, counts, options)
  columns = %i[lines words chars].filter_map do |key|
    counts[key].to_s.rjust(8) if options[key]
  end
  columns << " #{file_name}" unless file_name.empty?
  puts columns.join
end

def parse_options
  options = { lines: false, words: false, chars: false }
  OptionParser.new do |opt|
    options.each_key do |key|
      opt.on("-#{key[0]}") { options[key] = true }
    end
  end.parse!

  if options.values.none?
    options.transform_values { true }
  else
    options
  end
end

def build_file_info_list
  if ARGV.empty?
    [{ file_content: ARGF.read, file_name: '' }]
  else
    ARGV.map do |file_name|
      { file_content: File.read(file_name), file_name: }
    end
  end
end

main
