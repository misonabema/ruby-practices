def number(n)
    if n % 15 == 0
        n = 'FizzBuzz'
    elsif n % 3 == 0
        n = 'Fizz'
    elsif n % 5 == 0
        n = 'Buzz'
    end
    n.to_s
end

20.times {|n| puts number(n + 1)}
