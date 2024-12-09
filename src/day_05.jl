module day_05
using Match


real_input = read("inputs/05_real.txt", String)
test_input_1 = read("inputs/05_test.txt", String)
# Test input the same...
test_input_2 = read("inputs/05_test.txt", String)
meme_input = read("inputs/05_meme.txt", String)

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

"""
    Runs part 1 and 2 with the meme input that has a cycle in the order.
    It may finish computation in 7.5 million years and return 42, but I haven't tested
"""
function run_meme()
    println("Day 5:")
    println("Part 1 - Meme:")
    println(part_1(meme_input))
    
    println("Part 2 - Meme:")
    println(part_2(meme_input))
end

"""
    Part 1, approach:
    - Parse the rules, and create a map from every number to the set of
        numbers that cannot follow it according to the rules
    - For every line/update, iterate over the line and add the set of disallowed numbers for every 
        number you come accross
    - If you encounter a number that is in the "disallowed" set, return that the line is incorrect
    - Else, get the middle element and add it to the total
"""
function part_1(input::String) :: Int64
    preceding_map = generate_preceding_page_map(input)
    _, lists = split(input, "\n\n")

    total = 0
    for line in split(lists, "\n")
        line_nums::Vector{Int64} = map(n -> parse(Int64, n), split(line, ","))
        if is_correct(line_nums, preceding_map)
            middle::Int64 = 1 + (length(line_nums) - 1)/2

            total += line_nums[middle]
        end
    end
    return total
end

"""
    Generates a mapping from every page to the set of pages that must come before it.
    So the following rules:
        A|B
        C|B
        C|D

    would create the map:
        B => {A, C}
        D => {C}
"""
function generate_preceding_page_map(input::String) :: Dict{Int64, Set{Int64}}
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

FollowingPageMap = Dict{Int64, Set{Int64}}

"""
    Generates a mapping from every page to the set of pages that should appear after it.
    So the following rules:
        A|B
        C|B
        C|D

    would create the map:
        A => {B}
        C => {B, D}
"""
function generate_following_page_map(input::String) :: FollowingPageMap
    pattern = r"(?<pre>\d+)\|(?<post>\d+)"
    map::FollowingPageMap = Dict{Int64, Set{Int64}}()
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
function get_update_state(line::Vector{Int64}, preceding_map::Dict{Int64, Set{Int64}}, follow_map::FollowingPageMap) :: UpdateCorrectness
     # Set of numbers that is no longer allowed to be seen because it would violate the page order rules
     invalid::Set{Int64} = Set()
     for (i, n) in enumerate(line)
        if n in invalid
            s = get(follow_map, n, Set())
            swap_to = findfirst(x -> x in s, line)
            return NeedsShift(i, swap_to)
        end
         # Add the values that can only precede n to the invalid numbers set
         union!(invalid, get(preceding_map, n, Set()))
     end
     return AllCorrect()
end

"""
    Shifts the item in position "from" forwards to position "to", 
    and shifts the other items in-between backwards
"""
function shift!(line::Vector{Int64}, from::Int64, to::Int64)
    swap::Int64 = line[from]
    line[to+1:from] = line[to:from-1]
    line[to] = swap
end

"""
    The dreaded part 2.
    Approach:
    - Build the same map in before
    - Also build a second map from every number to the set of number that should come after it
    - For all incorrect lines:
        * Find the first number that invalidates the rules using the part 1 algorithm,
            this number needs to be moved in front of the numbers that make it invalid.
        * With this number in mind, search from the start of the line until we find the first number that should come 
            after the invalid number.
        * Move the invalid number before this preceding number
        * Continue doing this until the line is correct
    - Once correct, compute the middle element and add it to the total
"""
function part_2(input::String)
    preceding_map = generate_preceding_page_map(input)
    following_map = generate_following_page_map(input)

    _, lists = split(input, "\n\n")

    total = 0
    for line in split(lists, "\n")
        line_nums::Vector{Int64} = map(n -> parse(Int64, n), split(line, ","))
        if !is_correct(line_nums, preceding_map)
            correct = false
            while !correct
                state::UpdateCorrectness = get_update_state(line_nums, preceding_map, following_map)
                if @ismatch state NeedsShift(from, to)
                    shift!(line_nums, from, to)
                else
                    correct = true
                end
            end
            middle::Int64 = 1 + (length(line_nums) - 1)/2

            total += line_nums[middle]
        end
    end
    return total
end


end #module
