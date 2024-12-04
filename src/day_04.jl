module day_04

real_input = read("inputs/04_real.txt", String)
test_input_1 = read("inputs/04_test_p1.txt", String)
# test_input_2 = read("inputs/04_test_p2.txt", String)

function run()
    println("Day 3:")
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
    split_inp = split(input, "\n")
    rows = length(split_inp)
    cols = length(split_inp[1])
    # grid::Array{Char, 2} = Array{Char}(undef, rows, cols)
    # for row in eachindex(split_inp)
    #     grid[row] = split_inp[row]
    # end
    grid = reduce(vcat, permutedims.(collect.(split_inp)))


    rows, cols = size(grid)
    count = 0
    for row in 1:rows
        for col in 1:cols
            for direction in [(0,1), (1,0),(0,-1),(-1,0), (1,1), (-1,1), (1, -1), (-1,-1)]
                matches = match_xmas(grid, (row, col), direction)
                if matches
                    count += 1
                end
            end
        end
    end
    return count
end

function match_xmas(grid :: Array{Char, 2}, start :: Tuple{Int64, Int64}, direction :: Tuple{Int64, Int64}) :: Bool
    rows, cols = size(grid)
    for (i, char) in enumerate("XMAS")
        row, col = start .+ direction .* (i-1)
        if !(row in 1:rows && col in 1:cols)
            return false
        end

        if char != grid[row, col]
            return false
        end
    end
    return true
end

end #module

day_04.run()