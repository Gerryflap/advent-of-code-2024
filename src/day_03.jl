module day_03
using Match
using Format

real_input = read("inputs/03_real.txt", String)
test_input_1 = read("inputs/03_test_p1.txt", String)
test_input_2 = read("inputs/03_test_p2.txt", String)

function run()
    println("Day 3:")
    println("Part 1 - Test:")
    println(part_1(test_input_1))
    println("Part 1 - Real:")
    println(part_1(real_input))
    
    println("Part 2 - Test:")
    println(part_2(test_input_2))
    println("Part 2 - Real:")
    println(part_2(real_input))
end

function part_1(input::String) :: Int64
    match_string = r"mul\((?<n1>\d+),(?<n2>\d+)\)"
    matches = eachmatch(match_string, input)
    total = 0
    for m in matches
        n1 = parse(Int64, m[:n1])
        n2 = parse(Int64, m[:n2])
        total += n1 * n2
    end
    return total
end

function part_2(input::String) :: Int64
    all_instr_regex = r"(mul\((?<n1>\d+),(?<n2>\d+)\))|((?<instr>(do|don't))\(\))"
    matches = eachmatch(all_instr_regex, input)
    total = 0
    enabled = true
    for m in matches
        if !isnothing(m[:instr])
            enabled = @match m[:instr] begin
                "do" => true
                "don't" => false
            end

        else
            if enabled
                n1 = parse(Int64, m[:n1])
                n2 = parse(Int64, m[:n2])
                total += n1 * n2
            end
        end
    end
    return total    
end


end #module day_03

day_03.run()