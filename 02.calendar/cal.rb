#!/usr/bin/env ruby

require 'date'
#コマンドライン引数の戻り値で表示年月を指定
require 'optparse'
$assign = ARGV.getopts("m:y:")

#指定がなければ今月を定義
def month
    if $assign["m"] == nil
        Date.today.month 
    else
        $assign["m"].to_i
    end
end

#指定がなければ今年を定義
def year
    if $assign["y"] == nil
        Date.today.year 
    else
        $assign["y"].to_i
    end
end

#月と年を表示
puts "#{month}月 #{year}".center(20) #中央に年月を表示

#曜日を横並びに表示
puts "日 月 火 水 木 金 土"

#指定した月の初日と末日を取得
initialday = Date.new(year, month, +1) 
lastday = Date.new(year, month, -1) 

#日付を表示
print "   " * initialday.wday #１日を曜日によってずらす
(initialday..lastday).each do |a| 
    if a.saturday? #土曜で折り返す 
        if a.day <= 9 #一桁なら手前にスペース入れる
            puts " #{a.day} "
        else
            puts a.day
        end
    else
        if a.day <= 9
            print " #{a.day} "
        else
            print "#{a.day} "
        end
    end
end
