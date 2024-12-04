module day_04

real_input = read("inputs/04_real.txt", String)
test_input_1 = read("inputs/04_test_p1.txt", String)
# Test input the same...
test_input_2 = read("inputs/04_test_p1.txt", String)

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
    # Transform into char matrix
    split_inp = split(input, "\n")
    rows = length(split_inp)
    cols = length(split_inp[1])
    grid = reduce(vcat, permutedims.(collect.(split_inp)))


    rows, cols = size(grid)

    # From every position in the matrix, go in every direction to try and match XMAS
    count = 0
    for row in 1:rows
        for col in 1:cols
            # All directions, inlcuding diagonal
            for direction in [(0,1), (1,0),(0,-1),(-1,0), (1,1), (-1,1), (1, -1), (-1,-1)]
                matches = match_string("XMAS", grid, (row, col), direction)
                if matches
                    count += 1
                end
            end
        end
    end
    return count
end

"""
    Checks whether the given string occurs in the given character matrix from the given position into the given direction .
    This method will also return false when it goes out of bounds, so no need to do bound checks anywhere else.
"""
function match_string(string_to_match::String, grid :: Array{Char, 2}, start :: Tuple{Int64, Int64}, direction :: Tuple{Int64, Int64}) :: Bool
    rows, cols = size(grid)
    for (i, char) in enumerate(string_to_match)
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

function part_2(input::String) :: Int64
    split_inp = split(input, "\n")
    rows = length(split_inp)
    cols = length(split_inp[1])
    grid = reduce(vcat, permutedims.(collect.(split_inp)))


    rows, cols = size(grid)
    count = 0
    for row in 1:rows
        for col in 1:cols
            # Instead of starting at a position and going into a direction like part 1,
            #   the cross is centered around the current position.
            # Because of this, the actual starting position is the center minus the direction (due to a string of length 3)
            for dir_1 in [(1,1), (-1,-1)]
                for dir_2 in [(1,-1),(-1,1)]
                    # Match the X-pattern MAS
                    matches = match_string("MAS", grid, (row, col) .- dir_1, dir_1) &&
                        match_string("MAS", grid, (row, col) .- dir_2, dir_2)

                    if matches
                        count += 1
                    end
                end
            end
        end
    end
    return count
end

end #module

day_04.run()