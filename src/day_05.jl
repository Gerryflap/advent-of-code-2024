module day_05

real_input = read("inputs/05_real.txt", String)
test_input_1 = read("inputs/05_test.txt", String)
# Test input the same...
test_input_2 = read("inputs/05_test.txt", String)

function run()
    println("Day 5:")
    println("Part 1 - Test:")
    println(part_1(test_input_1))
    println("Part 1 - Real:")
    println(part_1(real_input))
    
    # println("Part 2 - Test:")
    # println(part_2(test_input_2))
    # println("Part 2 - Real:")
    # println(part_2(real_input))
end


function part_1(input::String) :: Int64
    pre_map = generate_preceding_page_map(input)
    _, lists = split(input, "\n\n")

    total = 0
    for line in split(lists, "\n")
        line_nums::Vector{Int64} = map(n -> parse(Int64, n), split(line, ","))
        if is_correct(line_nums, pre_map)
            middle::Int64 = 1 + (length(line_nums) - 1)/2

            total += line_nums[middle]
        end
    end
    return total
end

function generate_preceding_page_map(input::String) :: Dict{Int64, Set{Int64}}
    pattern = r"(?<pre>\d+)\|(?<post>\d+)"
    map::Dict{Int64, Set{Int64}} = Dict{Int64, Set{Int64}}()
    for match in eachmatch(pattern, input)
        pre::Int64 = parse(Int64, match[:pre])
        post::Int64 = parse(Int64, match[:post])
        preceding_set::Set{Int64} = get!(() -> Set(), map, post)
        push!(preceding_set, pre)
    end
    return map
end

function is_correct(line::Vector{Int64}, pre_map::Dict{Int64, Set{Int64}}) :: Bool
    # Set of numbers that is no longer allowed to be seen because it would violate the page order rules
    invalid::Set{Int64} = Set()
    for n in line
        if n in invalid
            return false
        end
        # Add the values that can only precede n to the invalid numbers set
        union!(invalid, get(pre_map, n, Set()))
    end
    return true
end


end #module

day_05.run()