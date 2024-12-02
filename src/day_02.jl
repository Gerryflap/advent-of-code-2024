module day_02

real_input = read("inputs/02_real.txt", String)
test_input_1 = read("inputs/02_test_p1.txt", String)
test_input_2 = read("inputs/02_test_p2.txt", String)

function run()
    println("Day 2:")
    println("Part 1 - Test:")
    println(part_1(test_input_1))
    println("Part 1 - Real:")
    println(part_1(real_input))
    
    # println("Part 2 - Test:")
    # println(part_2(test_input_2))
    # println("Part 2 - Real:")
    # println(part_2(real_input))
end

Level = Array{Int64, 1}

function part_1(input::String) :: Int64
    lines::Vector{String} = split(input, "\n")
    levels::Vector{Level} = map(parse_lvl, lines)
    return count(is_safe, levels)
end

function parse_lvl(input::String) :: Level
    split_str::Vector{String} = split(input)
    parsed = map(str -> parse(Int64, str), split_str)
    return parsed
end

function is_safe(level::Level) :: Bool
    diffs = map(((x, y),) -> x - y, zip(level[2:end], level[1:end-1]))
    return all(n -> n in 1:3, diffs) || all(n -> n in -3:-1, diffs)
end

end #module day_02