module day_05
using Match


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
    
    println("Part 2 - Test:")
    println(part_2(test_input_2))
    println("Part 2 - Real:")
    println(part_2(real_input))
end


function part_1(input::String) :: Int64
    pre_map = generate_disallowed_following_page_map(input)
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

"""
    Generates a mapping from every page to the set of pages that cannot come after it.
    So the following rules:
        A|B
        C|B
        C|D

    would create the map:
        B => {A, C}
        D => {C}
"""
function generate_disallowed_following_page_map(input::String) :: Dict{Int64, Set{Int64}}
    pattern = r"(?<pre>\d+)\|(?<post>\d+)"
    map::Dict{Int64, Set{Int64}} = Dict{Int64, Set{Int64}}()
    for match in eachmatch(pattern, input)
        pre::Int64 = parse(Int64, match[:pre])
        post::Int64 = parse(Int64, match[:post])
        no_follow_set::Set{Int64} = get!(() -> Set(), map, post)
        push!(no_follow_set, pre)
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

PrecedingPageMap = Dict{Int64, Set{Int64}}

"""
    Generates a mapping from every page to the set of pages that should appear before it.
    So the following rules:
        A|B
        C|B
        C|D

    would create the map:
        A => {B}
        C => {B, D}
"""
function generate_preceding_page_map(input::String) :: PrecedingPageMap
    pattern = r"(?<pre>\d+)\|(?<post>\d+)"
    map::PrecedingPageMap = Dict{Int64, Set{Int64}}()
    for match in eachmatch(pattern, input)
        pre::Int64 = parse(Int64, match[:pre])
        post::Int64 = parse(Int64, match[:post])
        preceding_set::Set{Int64} = get!(() -> Set(), map, pre)
        push!(preceding_set, post)
    end
    return map
end
# The update is correct, all page numbers are in order
struct AllCorrect end

# The list of page numbers needs at least the following shift to continue
struct NeedsShift
    from::Int64
    to::Int64
end

# Represents the correctness of an update (list of page numbers)
UpdateCorrectness = Union{AllCorrect, NeedsShift}

"""
    Gets the state of the update list
"""
function get_update_state(line::Vector{Int64}, no_follow_map::Dict{Int64, Set{Int64}}, pre_map::PrecedingPageMap) :: UpdateCorrectness
     # Set of numbers that is no longer allowed to be seen because it would violate the page order rules
     invalid::Set{Int64} = Set()
     for (i, n) in enumerate(line)
        if n in invalid
            s = get(pre_map, n, Set())
            swap_to = findfirst(x -> x in s, line)
            return NeedsShift(i, swap_to)
        end
         # Add the values that can only precede n to the invalid numbers set
         union!(invalid, get(no_follow_map, n, Set()))
     end
     return AllCorrect()
end

function shift!(line::Vector{Int64}, from::Int64, to::Int64)
    swap::Int64 = line[from]
    line[to+1:from] = line[to:from-1]
    line[to] = swap
end

function part_2(input::String)
    follow_map = generate_disallowed_following_page_map(input)
    pre_map = generate_preceding_page_map(input)

    _, lists = split(input, "\n\n")

    total = 0
    for line in split(lists, "\n")
        line_nums::Vector{Int64} = map(n -> parse(Int64, n), split(line, ","))
        if !is_correct(line_nums, follow_map)
            correct = false
            while !correct
                state::UpdateCorrectness = get_update_state(line_nums, follow_map, pre_map)
                if typeof(state) == AllCorrect
                    correct = true
                else
                    shift!(line_nums, state.from, state.to)
                end
            end
            middle::Int64 = 1 + (length(line_nums) - 1)/2

            total += line_nums[middle]
        end
    end
    return total
end


end #module

day_05.run()