#!/usr/bin/env ruby
# frozen_string_literal: true

LAST_FRAME_SHOT = 18
LAST_FRAME = 9
score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0 if shots.count < LAST_FRAME_SHOT
  else
    shots << s.to_i
  end
end

frames = shots.each_slice(2).to_a

point = frames.each_with_index.sum do |frame, i|
  next_frame = frames[i + 1]
  if i < LAST_FRAME
    if frame[0] == 10
      if next_frame[0] == 10 && i != LAST_FRAME - 1
        20 + frames[i + 2][0]
      else
        10 + next_frame.sum
      end
    elsif frame.sum == 10
      10 + next_frame[0]
    else
      frame.sum
    end
  else
    frame.sum
  end
end
puts point
