def num(n)
    if n % 15 == 0
        n = 'fizzbuzz'
    elsif n % 3 == 0
        n = 'fizz'
    elsif n % 5 == 0
        n = 'buzz'
    end
    n.to_s
end

n = 0
20.times do
    n += 1
    puts num(n)
end
