#!/usr/bin/env ruby

# frozen_string_literal: true

require 'rubygems'

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0 if shots.count <= 17 # ９フレームまで
  else
    shots << s.to_i
  end
end

last_frame = shots.slice!(18..)
frames = shots.each_slice(2).to_a
frames.push(last_frame)

point = 0
frames.each_with_index do |frame, i|
  point += if i <= 8 # 9フレームまで
             if frame[0] == 10 # ストライク
               if frames[i + 1][0] == 10 && i != 8 # ダブル
                 20 + frames[i + 2][0]
               else
                 10 + frames[i + 1][0] + frames[i + 1][1]
               end
             elsif frame.sum == 10 # スペア
               10 + frames[i + 1][0]
             else
               frame.sum
             end
           else
             frame.sum # 最終フレーム
           end
end
puts point
