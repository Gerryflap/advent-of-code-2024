module old_day_01_2023

real_input = read("inputs/old_real_01_2023.txt", String)
test_input_1 = read("inputs/old_test_01_2023_part_1.txt", String)
test_input_2 = read("inputs/old_test_01_2023_part_2.txt", String)

"""
        part_1(input)

    Compute the result for part 1 of aoc 2023 day 1
"""
function part_1(input::String) :: Int
    total = 0
    for line in split(input, "\n")
        numbers = filter(isdigit, line)
        fst = numbers[1]
        lst = numbers[end]
        n = string(fst, lst)
        total += parse(Int, n)
    end
    return total
end

"""
        part_2(input)

    WARNING: Doesn't actually work because it replaces the strings. But irrelevant for 2024 as this just serves as an example    
    Compute the result for part 2 of aoc 2023 day 1
"""
function part_2(input::String) :: Int
    numbers = [
        "one" =>    "1"
        "two" =>    "2"
        "three" =>  "3"
        "four" =>   "4"
        "five" =>   "5"
        "six" =>    "6"
        "seven" =>  "7"
        "eight" =>  "8"
        "nine" =>   "9"
    ]

    return part_1(replace(input, numbers...))
end

function run()
    println("Day 1 (OLD, 2023):")
    println("Part 1 - Test:")
    println(part_1(test_input_1))
    println("Part 1 - Real:")
    println(part_1(real_input))
    
    println("Part 2 - Test:")
    println(part_2(test_input_2))
    println("Part 2 - Real:")
    println(part_2(real_input))
end

end #module old_day_01_2023