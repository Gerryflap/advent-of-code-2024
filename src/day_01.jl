module day_01

real_input = read("inputs/01_real.txt", String)
test_input_1 = read("inputs/01_test_p1.txt", String)
test_input_2 = read("inputs/01_test_p2.txt", String)

function run()
    println("Day 1:")
    println("Part 1 - Test:")
    println(part_1(test_input_1))
    println("Part 1 - Real:")
    println(part_1(real_input))
    
    println("Part 2 - Test:")
    println(part_2(test_input_2))
    println("Part 2 - Real:")
    println(part_2(real_input))
end

function part_1(input::String)
    numbers = parse_input(input)
    sorted = sort(numbers, dims=1)
    total_distance = sum(abs.(sorted[:, 1] - sorted[:, 2]))
    return total_distance
end

# Fck it, O(n²) it is...
function part_2(input::String)
    numbers = parse_input(input)
    similarity_score = 0
    for n in numbers[:, 1]
        # nyooooom! Such code, many fast
        similarity_score += n * count(m -> m == n, numbers[:, 2])
    end
    return similarity_score
end

"""
        parse_input(input)

    Parses the input string into an Int64 array of size (N, 2) where N is the amount of lines in the input string.
    Expects an input of any number of lines with 2 numbers split by whitespace on every row.
"""
function parse_input(input::String) :: Array{Int64, 2}
    split_rows = split(input, "\n")
    numbers = zeros(Int64, length(split_rows), 2)
    for (i, row) in enumerate(split_rows)
        l, r = split(row)
        numbers[i, 1] = parse(Int64, l)
        numbers[i, 2] = parse(Int64, r)
    end
    return numbers
end
end #module day_0
