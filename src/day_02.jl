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
    
    println("Part 2 - Test:")
    println(part_2(test_input_2))
    println("Part 2 - Real:")
    println(part_2(real_input)) 
end

Report = Array{Int64, 1}

function part_1(input::String) :: Int64
    lines::Vector{String} = split(input, "\n")
    levels::Vector{Report} = map(parse_lvl, lines)
    return count(is_safe_1, levels)
end

function parse_lvl(input::String) :: Report
    split_str::Vector{String} = split(input)
    parsed = map(str -> parse(Int64, str), split_str)
    return parsed
end

function is_safe_1(report::Report) :: Bool
    diffs = map(((x, y),) -> x - y, zip(report[2:end], report[1:end-1]))
    return all(n -> n in 1:3, diffs) || all(n -> n in -3:-1, diffs)
end


# ========== Part 2 ==========
function part_2(input::String)
    lines::Vector{String} = split(input, "\n")
    reports::Vector{Report} = map(parse_lvl, lines)
    return count(is_safe_2, reports)
end

function is_safe_2(report::Report) :: Bool
    return is_safe_2(report, 1:3) || is_safe_2(report, -3:-1)
end

# This can probably be done way simpler, but whatever
function is_safe_2(report::Report, acceptable_range::UnitRange{Int64}) :: Bool
    bad_level::Union{Nothing, Int64} = nothing

    for i in eachindex(report)[1:end-1]
        # Skip if this is the bad level (as marked by a previous )
        if !isnothing(bad_level) && i == bad_level
            continue
        end
        
        if !(report[i] - report[i+1] in acceptable_range)
            # Uh oh...
            if !isnothing(bad_level) && i != bad_level
                # Not safe, we have already used our bad level
                return false
            end
            
            if !(i+2 in eachindex(report)) 
                # Bad element i+1 is the last element and we haven't used the bad element, return that this report is safe
                return true
            elseif report[i] - report[i+2] in acceptable_range
                # i+1 can be skipped to fix this mess, so let's mark it as bad
                bad_level = i+1
            elseif i-1 in eachindex(report) && (report[i-1] - report[i+1] in acceptable_range)
                # i is the problem, mark as bad and continue
                bad_level = i
            elseif !(i-1 in eachindex(report))
                # We're the first element, and i+1 cannot be skipped, so skip ourselves
                bad_level = i
            else
                # No possible solution, even using the permitted level. Just give up...
                return false
            end
        end
    end
    return true
end
end #module day_02
